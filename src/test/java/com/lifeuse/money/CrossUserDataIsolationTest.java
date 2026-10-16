package com.lifeuse.money;

import com.lifeuse.common.ResourceNotFoundException;
import com.lifeuse.money.models.entity.FinancialTransaction;
import com.lifeuse.money.repository.IMoneyRepository;
import com.lifeuse.money.service.IMoneyCalculationService;
import com.lifeuse.money.service.MoneyService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Cross-User Multi-Tenant Isolation Security Tests")
class CrossUserDataIsolationTest {

    @Mock
    private IMoneyRepository moneyRepository;

    @Mock
    private IMoneyCalculationService calculationService;

    @InjectMocks
    private MoneyService moneyService;

    private final Long userA = 101L;
    private final Long userB = 202L;
    private final Long resourceId = 555L;

    @Test
    @DisplayName("User A cannot read User B's transaction — throws ResourceNotFoundException")
    void userACannotReadUserBTransaction() {
        // User B owns resourceId, so repository query filtered by userA returns Optional.empty()
        when(moneyRepository.findTransactionById(resourceId, userA)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class, () ->
                moneyService.getTransactionById(userA, resourceId)
        );

        verify(moneyRepository).findTransactionById(resourceId, userA);
        verify(moneyRepository, never()).findTransactionById(resourceId, userB);
    }

    @Test
    @DisplayName("User A cannot delete User B's transaction — throws ResourceNotFoundException")
    void userACannotDeleteUserBTransaction() {
        when(moneyRepository.deleteTransaction(resourceId, userA)).thenReturn(false);

        assertThrows(ResourceNotFoundException.class, () ->
                moneyService.deleteTransaction(userA, resourceId)
        );

        verify(moneyRepository).deleteTransaction(resourceId, userA);
    }

    @Test
    @DisplayName("User A cannot delete User B's savings goal — throws ResourceNotFoundException")
    void userACannotDeleteUserBSavingsGoal() {
        when(moneyRepository.deleteSavingsGoal(resourceId, userA)).thenReturn(false);

        assertThrows(ResourceNotFoundException.class, () ->
                moneyService.deleteSavingsGoal(userA, resourceId)
        );

        verify(moneyRepository).deleteSavingsGoal(resourceId, userA);
    }

    @Test
    @DisplayName("User A cannot delete User B's financial commitment — throws ResourceNotFoundException")
    void userACannotDeleteUserBFinancialCommitment() {
        when(moneyRepository.deleteCommitment(resourceId, userA)).thenReturn(false);

        assertThrows(ResourceNotFoundException.class, () ->
                moneyService.deleteCommitment(userA, resourceId)
        );

        verify(moneyRepository).deleteCommitment(resourceId, userA);
    }

    @Test
    @DisplayName("User A cannot delete User B's planned expense — throws ResourceNotFoundException")
    void userACannotDeleteUserBPlannedExpense() {
        when(moneyRepository.deletePlannedExpense(resourceId, userA)).thenReturn(false);

        assertThrows(ResourceNotFoundException.class, () ->
                moneyService.deletePlannedExpense(userA, resourceId)
        );

        verify(moneyRepository).deletePlannedExpense(resourceId, userA);
    }

    @Test
    @DisplayName("User A cannot delete User B's budget plan — throws ResourceNotFoundException")
    void userACannotDeleteUserBBudgetPlan() {
        when(moneyRepository.deleteBudgetPlan(resourceId, userA)).thenReturn(false);

        assertThrows(ResourceNotFoundException.class, () ->
                moneyService.deleteBudgetPlan(userA, resourceId)
        );

        verify(moneyRepository).deleteBudgetPlan(resourceId, userA);
    }
}
