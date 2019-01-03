/*
 * ÀÛ¼ºµÈ ³¯Â¥: 2005. 1. 28.
 *
 */
package servlet.hris;

import com.common.ExcelUtils;
import com.common.vo.ReadExcelInputVO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.G.G001Approval.ApprovalDocList;
import hris.ResetExcelUploadData;
import hris.common.WebUserData;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.Vector;

/**
 * @author ÀÌ½ÂÈñ
 */
public class ResetApporvalExcelSV extends EHRBaseServlet {

    /* (ºñJavadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException {

        try {
            req.setAttribute("viewSource", "true");

            Box box = WebUtil.getBox(req);
            WebUserData user = WebUtil.getSessionUser(req);

            String jobid = box.get("jobid", "first");


            if("upload".equals(jobid)) {
                ReadExcelInputVO excelInputVO = new ReadExcelInputVO((DiskFileItem) box.getObject("uploadFile"), ResetExcelUploadData.class,
                        Arrays.asList("AINF_SEQN", "PERNR"), 1);

                Vector<ResetExcelUploadData> excelResultList = ExcelUtils.readExcel(excelInputVO);

                Vector<ResetExcelUploadData> resultList = new Vector<ResetExcelUploadData>();
                for(ResetExcelUploadData row : excelResultList) {
                    if(StringUtils.isBlank(row.PERNR) && StringUtils.isBlank(row.AINF_SEQN)) {
                        continue;
                    }
                    resultList.add(row);
                }

                /*resultList.add(new ResetExcelUploadData("123", "10000166"));
                resultList.add(new ResetExcelUploadData("222", "10000166"));
                resultList.add(new ResetExcelUploadData("3333", "10000166"));
                resultList.add(new ResetExcelUploadData("4444", "10000166"));

                resultList.add(new ResetExcelUploadData("5555", "10000166"));
                resultList.add(new ResetExcelUploadData("6666", "10000166"));*/

                req.setAttribute("resultList", resultList);
                req.setAttribute("isSuccess", true);
                req.setAttribute("showEloffice", box.get("showEloffice"));
            }

            printJspPage(req, res, WebUtil.JspURL + "resetApprovalExcel.jsp");
        }  catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }finally {

        }
    }

    private ApprovalDocList findApproval(Vector<ApprovalDocList> vcApprovalDocList, String AINF_SEQN ) {

        for(ApprovalDocList row : vcApprovalDocList) {
            if(StringUtils.equals(row.AINF_SEQN, AINF_SEQN)) return row;
        }

        return null;
    }
}
