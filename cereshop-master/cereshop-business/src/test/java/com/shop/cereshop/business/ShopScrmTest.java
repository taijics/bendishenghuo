package com.shop.cereshop.business;

import com.shop.cereshop.business.utils.ScrmSyncVerifyUtil;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

/**
 * scrm同步数据测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class ShopScrmTest {

    @Autowired
    private ScrmSyncVerifyUtil scrmSyncVerifyUtil;

    @Test
    public void testVerify() throws Exception {
        Long shopId = 0L;
        String secret = "admin";
        scrmSyncVerifyUtil.verify(shopId, secret);
    }

}
