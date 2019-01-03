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
            /* template ��� ���� ��� */
            if(type.equals("D")) {
                ExcelMap excelMap = ExcelMap.getInstance("sample.xls");

                LinkedHashMap<String, String> header = new LinkedHashMap<String, String>();
                header.put("colString", "���ڿ�");
                header.put("colInteger", "������");
                header.put("colFloat", "�Ǽ���");
                header.put("colDate", "��¥��");
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
                excelMap.put("title", "�������ø� �׽�Ʈ");
//                excelMap.put("header", Utils.asMap("code_group", "�ڵ�׷�", "group_nm", "�׷��", "biz_cd", "�����ڵ�"));
                excelMap.put("header", new ExcelTemplateEntity("�ڵ�׷�", "�׷��", "�����ڵ�"));



                excelMap.put("resultList", Arrays.asList(
                                Utils.asMap("code_group", "group1", "group_nm", "�׷�1", "biz_cd", "����1"),
                                Utils.asMap("code_group", "group2", "group_nm", "�׷�2", "biz_cd", "����2"),
                                Utils.asMap("code_group", "group3", "group_nm", "�׷�3", "biz_cd", "����3"))
                );
               /*
                excelMap.put("resultList",
                        Arrays.asList(
                                new ExcelTemplateEntity("group1", "�׷�1", "����1"),
                                new ExcelTemplateEntity("group2", "�׷�2", "����2"),
                                new ExcelTemplateEntity("group3", "�׷�3", "����3"))
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
