package com.util;

import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

public class ReadExcel {
    /**
     * 根据读取excel数据信息
     * @param path
     * @return
     */
    public static List<Object> readExcelInfo(String path) throws IOException {
        List<Object> result=new ArrayList<>();
        XSSFWorkbook wb = new XSSFWorkbook(path);
        XSSFCell cell = null;
        XSSFSheet sheet = wb.getSheetAt(0);//获取第一个sheet里面的内容
        //遍历行信息
        for (int rowIndex =1; rowIndex <=sheet.getLastRowNum(); rowIndex++) {
            //获取每一行数据信息
            XSSFRow row = sheet.getRow(rowIndex);
            List<String> data=new ArrayList<>();//存放每一行数据信息
            for (int columnIndex =0; columnIndex <row.getLastCellNum(); columnIndex++) {
                String value = "";
                cell = row.getCell(columnIndex);
                if(cell!=null) {
                    value=getValueByCell(cell);
                    if(value!=null&&!"".equals(value)) {
                        //存放每一行的数据信息
                        data.add(value);
                    }
                }
            }
            //存放数据信息
            result.add(data);
        }
        return result;
    }

    /**
     * 读取excel列里面的信息
     * @param cell
     * @return
     */
    private static String getValueByCell(XSSFCell cell) {
        String value=null;
        if(cell!=null) {
            switch (cell.getCellType()) {
                case XSSFCell.CELL_TYPE_STRING:
                    value = cell.getStringCellValue();
                    break;
                case XSSFCell.CELL_TYPE_NUMERIC : // 数字
                    if(HSSFDateUtil.isCellDateFormatted(cell)){
                        Date date = cell.getDateCellValue();
                        if(date!=null){
                            value = new SimpleDateFormat("yyyy-MM-dd").format(date);
                        }else{
                            value = "";
                        }
                    }else{
                        Object inputValue = null;// 单元格值
                        Long longVal = Math.round(cell.getNumericCellValue());
                        Double doubleVal = cell.getNumericCellValue();
                        if(Double.parseDouble(longVal + ".0") == doubleVal){   //判断是否含有小数位.0
                            inputValue = longVal;
                        }
                        else{
                            inputValue = doubleVal;
                        }
                        value =String.valueOf(inputValue);
                    }
                    break;
                case XSSFCell.CELL_TYPE_BLANK:
                    break;
                case XSSFCell.CELL_TYPE_ERROR:
                    value = "";
                    break;
                default:
                    value = cell.toString();
                    break;
            }
        }else {
            value="";
        }
        return value;
    }
}
