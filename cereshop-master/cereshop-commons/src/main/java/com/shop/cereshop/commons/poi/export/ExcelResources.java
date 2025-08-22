package com.shop.cereshop.commons.poi.export;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface ExcelResources {
  
 int order() default 9999;//定义字段在excel的单元格列坐标位置
 
 String title() default "";//定义列坐标对应的标题
 
 int cloumn() default 100;//定义列宽
 
 String pattern() default "";//定义日期显示格式
 
}