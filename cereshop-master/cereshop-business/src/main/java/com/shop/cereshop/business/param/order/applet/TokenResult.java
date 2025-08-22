package com.shop.cereshop.business.param.order.applet;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TokenResult {

    private String access_token;

    private String expires_in;
}
