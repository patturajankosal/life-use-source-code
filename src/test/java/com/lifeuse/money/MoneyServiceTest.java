package com.lifeuse.money;

import com.lifeuse.common.ResourceNotFoundException;
import com.lifeuse.money.models.dto.*;
import com.lifeuse.money.models.entity.*;
import com.lifeuse.money.models.enums.TransactionType;
import com.lifeuse.money.repository.IMoneyRepository;
import com.lifeuse.money.service.IMoneyCalculationService;
import com.lifeuse.money.service.MoneyService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Money Service Business Logic & Idempotency Tests")
class MoneyServiceTest {

    @Mock
    private IMoneyRepository moneyRepository;

    @Mock
    private IMoneyCalculationService calculationService;

    @InjectMocks
    private MoneyService moneyService;

    private Long userId = 1L;

    @BeforeEach
    void setUp() {
    }

    @Test
    @DisplayName("Should return existing transaction when duplicate idempotency key is submitted")
    void shouldReturnExistingTransactionWhenIdempotencyKeyMatches() {
        String idempotencyKey = "client-tx-uuid-12345";
        TransactionCreateRequest request = new TransactionCreateRequest();
        request.setTransactionType(TransactionType.EXPENSE);
        request.setCategoryName("Groceries");
        request.setAmount(new BigDecimal("500.00"));
        request.setIdempotencyKey(idempotencyKey);

        FinancialTransaction existingTx = new FinancialTransaction();
        existingTx.setId(99L);
        existingTx.setUserId(userId);
        existingTx.setTransactionType(TransactionType.EXPENSE);
        existingTx.setCategoryName("Groceries");
        existingTx.setAmount(new BigDecimal("500.00"));
        existingTx.setIdempotencyKey(idempotencyKey);
        existingTx.setCreatedAt(Instant.now());

        when(moneyRepository.findTransactionByIdempotencyKey(userId, idempotencyKey))
                .thenReturn(Optional.of(existingTx));

        TransactionResponse response = moneyService.createTransaction(userId, request);

        assertNotNull(response);
        assertEquals(99L, response.getId());
        assertEquals(idempotencyKey, response.getIdempotencyKey());
        verify(moneyRepository, never()).saveTransaction(any());
    }

    @Test
    @DisplayName("Should save new transaction when idempotency key is not seen before")
    void shouldSaveNewTransactionWhenIdempotencyKeyIsNew() {
        String idempotencyKey = "new-uuid-99999";
        TransactionCreateRequest request = new TransactionCreateRequest();
        request.setTransactionType(TransactionType.EXPENSE);
        request.setCategoryName("Dining");
        request.setAmount(new BigDecimal("350.00"));
        request.setIdempotencyKey(idempotencyKey);

        when(moneyRepository.findTransactionByIdempotencyKey(userId, idempotencyKey))
                .thenReturn(Optional.empty());

        when(moneyRepository.saveTransaction(any(FinancialTransaction.class))).thenAnswer(invocation -> {
            FinancialTransaction tx = invocation.getArgument(0);
            tx.setId(101L);
            return tx;
        });

        TransactionResponse response = moneyService.createTransaction(userId, request);

        assertNotNull(response);
        assertEquals(101L, response.getId());
        assertEquals("Dining", response.getCategoryName());
        assertEquals(new BigDecimal("350.00"), response.getAmount());
        verify(moneyRepository, times(1)).saveTransaction(any());
    }

    @Test
    @DisplayName("Should enforce multi-tenant isolation and throw exception if commitment does not belong to user")
    void shouldEnforceMultiTenancyOnCommitmentDeletion() {
        Long foreignCommitmentId = 42L;
        when(moneyRepository.deleteCommitment(foreignCommitmentId, userId)).thenReturn(false);

        assertThrows(ResourceNotFoundException.class, () ->
                moneyService.deleteCommitment(userId, foreignCommitmentId)
        );
    }

    @Test
    @DisplayName("Should execute planned expense into transaction successfully")
    void shouldExecutePlannedExpenseIntoTransaction() {
        Long plannedId = 7L;
        PlannedExpense planned = new PlannedExpense();
        planned.setId(plannedId);
        planned.setUserId(userId);
        planned.setTitle("Car Service");
        planned.setAmount(new BigDecimal("2500.00"));
        planned.setPlannedDate(LocalDate.now());
        planned.setCategoryName("Transportation");
        planned.setExecuted(false);

        when(moneyRepository.findPlannedExpenseById(plannedId, userId)).thenReturn(Optional.of(planned));
        when(moneyRepository.saveTransaction(any())).thenAnswer(invocation -> {
            FinancialTransaction tx = invocation.getArgument(0);
            tx.setId(205L);
            return tx;
        });

        TransactionResponse txResp = moneyService.executePlannedExpense(userId, plannedId);

        assertNotNull(txResp);
        assertEquals(205L, txResp.getId());
        assertEquals(new BigDecimal("2500.00"), txResp.getAmount());
        verify(moneyRepository).markPlannedExpenseExecuted(plannedId, userId, 205L);
    }
}
