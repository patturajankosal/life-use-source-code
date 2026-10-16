package com.lifeuse.money;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.lifeuse.AppRoutes;
import com.lifeuse.common.GlobalExceptionHandler;
import com.lifeuse.money.controller.TransactionController;
import com.lifeuse.money.models.dto.TransactionCreateRequest;
import com.lifeuse.money.models.dto.TransactionResponse;
import com.lifeuse.money.models.enums.PaymentMethod;
import com.lifeuse.money.models.enums.TransactionType;
import com.lifeuse.money.service.IMoneyService;
import com.lifeuse.user.models.Role;
import com.lifeuse.user.models.User;
import com.lifeuse.user.service.IUserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
@DisplayName("TransactionController REST API Tests")
class TransactionControllerTest {

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @Mock
    private IMoneyService moneyService;

    @Mock
    private IUserService userService;

    @InjectMocks
    private TransactionController transactionController;

    private User mockUser;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        mockUser = new User("testuser", "John", "Doe", "john@example.com", "+919876543210", "password", Role.ROLE_USER);
        mockUser.setId(1L);

        HandlerMethodArgumentResolver authPrincipalResolver = new HandlerMethodArgumentResolver() {
            @Override
            public boolean supportsParameter(MethodParameter parameter) {
                return parameter.hasParameterAnnotation(AuthenticationPrincipal.class);
            }

            @Override
            public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                          NativeWebRequest webRequest, WebDataBinderFactory binderFactory) {
                return mockUser;
            }
        };

        mockMvc = MockMvcBuilders.standaloneSetup(transactionController)
                .setCustomArgumentResolvers(authPrincipalResolver)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
    }

    @Test
    @DisplayName("POST /api/lifeUse/money/transactions - Successfully record a transaction")
    void shouldCreateTransactionSuccessfully() throws Exception {
        TransactionCreateRequest req = new TransactionCreateRequest();
        req.setTransactionType(TransactionType.EXPENSE);
        req.setCategoryName("Groceries");
        req.setAmount(new BigDecimal("450.00"));
        req.setPaymentMethod(PaymentMethod.UPI);
        req.setIdempotencyKey("idem-key-123");

        TransactionResponse resp = new TransactionResponse();
        resp.setId(10L);
        resp.setUserId(1L);
        resp.setTransactionType(TransactionType.EXPENSE);
        resp.setCategoryName("Groceries");
        resp.setAmount(new BigDecimal("450.00"));
        resp.setPaymentMethod(PaymentMethod.UPI);
        resp.setTransactionDate(Instant.now());
        resp.setCreatedAt(Instant.now());

        when(moneyService.createTransaction(eq(1L), any(TransactionCreateRequest.class))).thenReturn(resp);

        mockMvc.perform(post(AppRoutes.Money.POST_TRANSACTION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(10))
                .andExpect(jsonPath("$.data.categoryName").value("Groceries"))
                .andExpect(jsonPath("$.data.amount").value(450.00));
    }

    @Test
    @DisplayName("POST /api/lifeUse/money/transactions - Validation failure on zero or negative amount")
    void shouldFailValidationOnZeroAmount() throws Exception {
        TransactionCreateRequest req = new TransactionCreateRequest();
        req.setTransactionType(TransactionType.EXPENSE);
        req.setCategoryName("Groceries");
        req.setAmount(new BigDecimal("0.00")); // Invalid

        mockMvc.perform(post(AppRoutes.Money.POST_TRANSACTION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("VALIDATION_FAILED"));
    }

    @Test
    @DisplayName("GET /api/lifeUse/money/transactions - Retrieve transaction list")
    void shouldGetTransactionsList() throws Exception {
        TransactionResponse t1 = new TransactionResponse();
        t1.setId(1L);
        t1.setTransactionType(TransactionType.EXPENSE);
        t1.setCategoryName("Food");
        t1.setAmount(new BigDecimal("150.00"));

        when(moneyService.getTransactions(eq(1L), any(), any(), any(), any(), anyInt(), anyInt()))
                .thenReturn(List.of(t1));

        mockMvc.perform(get(AppRoutes.Money.GET_TRANSACTIONS))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data[0].id").value(1))
                .andExpect(jsonPath("$.data[0].categoryName").value("Food"));
    }
}
