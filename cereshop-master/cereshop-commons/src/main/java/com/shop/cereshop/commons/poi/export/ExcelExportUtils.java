package com.shop.cereshop.commons.poi.export;

import com.shop.cereshop.commons.poi.ImportExeclUtil;
import com.shop.cereshop.commons.utils.StringUtils;
import com.shop.cereshop.commons.utils.TimeUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

public class ExcelExportUtils {

  private static float title_row_height=35;//标题行高
  private static float data_row_height=25;//数据行高

 public static void exportExcel(HttpServletRequest request, HttpServletResponse response, String fileName , List<?> excelDatas, Class<?> clz ) {
    try {
      HSSFWorkbook resultWb=new HSSFWorkbook();
      HSSFSheet sheet=resultWb.createSheet();//创建sheet
      resultWb.setSheetName(0, fileName);
      //根据类类型信息获取导出的excel对应的标题和列宽 key-列号，value-标题和列宽
      HashMap<Integer, TitleAndCloumn> orderTitleAndCloumnMap=getTitleAndCloumnMap(clz);

      //设置列宽
      orderTitleAndCloumnMap.forEach((k,v) -> {
        sheet.setColumnWidth(k, v.getCloumn()*256);
      });

      HSSFRow row0=sheet.createRow(0);
      //设置标题行高
      row0.setHeightInPoints(title_row_height);

      //创建标题单元格格式
      HSSFCellStyle titleCellStyle=getCellStyle(resultWb,11,true,HSSFColor.BLACK.index,HSSFColor.WHITE.index);
      //填充标题行内容
      orderTitleAndCloumnMap.forEach((k,v) -> {
        HSSFCell row0Cell=row0.createCell(k);
        row0Cell.setCellValue(v.getTitle());
        row0Cell.setCellStyle(titleCellStyle);
      });

      //创建正文单元格格式
      HSSFCellStyle dataStyle = getCellStyle(resultWb,11,false, HSSFColor.BLACK.index,HSSFColor.WHITE.index);

      //将正文转换为excel数据
      int rowNum=1;
      for(Object data:excelDatas){

        HSSFRow row=sheet.createRow(rowNum++);
        row.setHeightInPoints(data_row_height);
        //获取对象值 key-列号 value-String值
        HashMap<Integer,String> orderValueMap=getValueMap(data);
        orderValueMap.forEach((k,v) ->{
          HSSFCell cell=row.createCell(k);
          cell.setCellValue(v);
          cell.setCellStyle(dataStyle);
            }
        );
      }

      String downFileName=fileName+"_"+ImportExeclUtil.DateUtil.dateToStr(new Date(),ImportExeclUtil.DateUtil.YYYYMMDDHHMMSS)+".xls";
      response.setContentType("application/vnd.ms-excel; charset=UTF-8");// application/x-download
      response.setHeader("Content-Disposition", "attachment; "
          +encodeFileName(request, downFileName));

      OutputStream outputStream = response.getOutputStream();
      resultWb.write(outputStream);
      outputStream.flush();
      outputStream.close();
      resultWb.close();
    }catch (Exception e1) {
      e1.printStackTrace();
    }
  }

  /**
   * 获取类的属性对应单元格标题和列宽
   * @param
   * @return
   */
  private static HashMap<Integer, TitleAndCloumn> getTitleAndCloumnMap(Class<?> clz) {
    HashMap<Integer, TitleAndCloumn> orderTitleAndCloumnMap=new HashMap<>();
    Field[] fs = clz.getDeclaredFields();
    for(Field f:fs) {
      f.setAccessible(true);
      if(f.isAnnotationPresent(ExcelResources.class)) {
        Integer order=f.getAnnotation(ExcelResources.class).order();
        String title=f.getAnnotation(ExcelResources.class).title();
        int cloumn=f.getAnnotation(ExcelResources.class).cloumn();
        TitleAndCloumn titleAndCloumn=new TitleAndCloumn(title,cloumn);
        orderTitleAndCloumnMap.put(order,titleAndCloumn);
      }
    }
    return orderTitleAndCloumnMap;
  }

  public static HSSFCellStyle getCellStyle(HSSFWorkbook workbook, int fontSize, boolean isBoleaWeight, short fontColor,short groundColor){
    HSSFCellStyle style = workbook.createCellStyle();
    style.setFillForegroundColor(groundColor); //设置要添加表格背景颜色
    style.setFillPattern(FillPatternType.SOLID_FOREGROUND); //solid 填充
    style.setAlignment(HorizontalAlignment.CENTER); //文字水平居中
    style.setVerticalAlignment(VerticalAlignment.CENTER);//文字垂直居中
    style.setBorderBottom(BorderStyle.THIN); //底边框加黑
    style.setBorderLeft(BorderStyle.THIN);  //左边框加黑
    style.setBorderRight(BorderStyle.THIN); // 右边框加黑
    style.setBorderTop(BorderStyle.THIN); //上边框加黑
    style.setWrapText(true);
    HSSFFont font = workbook.createFont();
    font.setFontHeightInPoints((short) fontSize);//字号
    font.setColor(fontColor);//颜色
    font.setFontName("宋体");//字体
    font.setBold(isBoleaWeight);
    style.setFont(font);
    return style;
  }

  /**
   * 获取对象的属性对应单元格坐标和值的键值对
   * @param obj
   * @return
   */
  private static HashMap<Integer, String> getValueMap(Object obj) throws IllegalAccessException {
    HashMap<Integer, String> result=new HashMap<>();
    Class<?> clz=obj.getClass();
    Field[] fs = clz.getDeclaredFields();
    for(Field f:fs) {
      f.setAccessible(true);
      if(f.isAnnotationPresent(ExcelResources.class)) {
        Integer order=f.getAnnotation(ExcelResources.class).order();
        String value="";
        Object valueObj=f.get(obj);
        if(valueObj!=null) {
          //日期格式进行特殊处理
          if(f.getType()== Date.class){
            String pattern=f.getAnnotation(ExcelResources.class).pattern();
            if(StringUtils.isEmpty(pattern)){
              pattern="yyyy-MM-dd HH:mm:ss";
            }
            SimpleDateFormat sdf=new SimpleDateFormat(pattern);
            value=sdf.format(valueObj);
          }else{
            value=valueObj.toString();//其他格式调用toString方法，这里枚举就需要定义自己的toString方法
          }

        }

        result.put(order, value);

      }
    }

    return result;
  }

  /**
   * 根据不同的浏览器生成不同类型中文文件名编码
   *
   * @param request
   * @param fileName
   * @return
   * @throws UnsupportedEncodingException
   */
  public static String encodeFileName(HttpServletRequest request, String fileName)
          throws UnsupportedEncodingException
  {

    String new_filename = URLEncoder.encode(fileName, "UTF8").replaceAll("\\+", "%20");

    String agent = request.getHeader("USER-AGENT").toLowerCase();
    if (null != agent && -1 != agent.indexOf("msie"))
    {
      /**
       * IE浏览器，只能采用URLEncoder编码
       */
      return "filename=\"" + new_filename +"\"";
    }else if (null != agent && -1 != agent.indexOf("applewebkit")){
      /**
       * Chrome浏览器，只能采用ISO编码的中文输出
       */
      return "filename=\"" + new String(fileName.getBytes("UTF-8"),"ISO8859-1") +"\"";
    } else if (null != agent && -1 != agent.indexOf("opera")){
      /**
       * Opera浏览器只可以使用filename*的中文输出
       * RFC2231规定的标准
       */
      return "filename*=" + new_filename ;
    }else if (null != agent && -1 != agent.indexOf("safari")){
      /**
       * Safani浏览器，只能采用iso编码的中文输出
       */
      return "filename=\"" + new String(fileName.getBytes("UTF-8"),"ISO8859-1") +"\"";
    }else if (null != agent && -1 != agent.indexOf("firefox"))
    {
      /**
       * Firfox浏览器，可以使用filename*的中文输出
       * RFC2231规定的标准
       */
      return "filename*=" + new_filename ;
    } else
    {
      return "filename=\"" + new_filename +"\"";
    }
  }

}

