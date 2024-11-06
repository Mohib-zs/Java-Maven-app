package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class ApplicationTest {

    @Test
    public void testGetStatus() {
        Application app = new Application();
        String status = app.getStatus();
        assertEquals("OK", status, "The status should be OK");
    }
}
