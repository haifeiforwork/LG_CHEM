package servlet.hris.sample;

import com.common.AjaxResultMap;
import com.common.ExcelMap;
import com.common.ExcelUtils;
import com.common.Utils;
import com.common.constant.Excel;
import com.common.vo.BaseVO;
import com.google.common.collect.Lists;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import org.springframework.web.bind.ServletRequestUtils;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * Created by manyjung on 2016-07-13.
 */
public class ExcelSampleSV extends EHRBaseServlet {

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            performTask(req, res);
        } catch(GeneralException e) {
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        String type = ServletRequestUtils.getStringParameter(req, "type", "D");

        try {
            /* template 사용 안할 경우 */
            if(type.equals("D")) {
                ExcelMap excelMap = ExcelMap.getInstance("sample.xls");

                LinkedHashMap<String, String> header = new LinkedHashMap<String, String>();
                header.put("colString", "문자열");
                header.put("colInteger", "정수형");
                header.put("colFloat", "실수형");
                header.put("colDate", "날짜형");
                excelMap.setHeader(header);

                ExcelContentSample row = new ExcelContentSample();
                row.colString = "test";
                row.colInteger = 12345678;
                row.colFloat = 3043.404f;
                row.colDate = Calendar.getInstance().getTime();

                List<ExcelContentSample> contents = new ArrayList<ExcelContentSample>();
                contents.add(row);
                excelMap.setContents(contents);

                ExcelUtils.writeExcel(req, res, excelMap);

            } else if(type.equals("T")) {

                ExcelMap excelMap = ExcelMap.getInstance("sample-template.xls", "template.xls");
                excelMap.put("title", "엑셀템플릿 테스트");
//                excelMap.put("header", Utils.asMap("code_group", "코드그룹", "group_nm", "그룹명", "biz_cd", "업무코드"));
                excelMap.put("header", new ExcelTemplateEntity("코드그룹", "그룹명", "업무코드"));



                excelMap.put("resultList", Arrays.asList(
                                Utils.asMap("code_group", "group1", "group_nm", "그룹1", "biz_cd", "업무1"),
                                Utils.asMap("code_group", "group2", "group_nm", "그룹2", "biz_cd", "업무2"),
                                Utils.asMap("code_group", "group3", "group_nm", "그룹3", "biz_cd", "업무3"))
                );
               /*
                excelMap.put("resultList",
                        Arrays.asList(
                                new ExcelTemplateEntity("group1", "그룹1", "업무1"),
                                new ExcelTemplateEntity("group2", "그룹2", "업무2"),
                                new ExcelTemplateEntity("group3", "그룹3", "업무3"))
                );
                  */
                ExcelUtils.writeExcel(req, res, excelMap);
            }
        } catch (Exception e) {
            Logger.error(e);
            Logger.error(e);
            throw new GeneralException(e);
        }


    }

}
