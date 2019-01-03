package servlet.hris.C;

import hris.C.C03LearnDetailData;
import hris.C.db.C03LearnDetailDB;
import hris.C.db.C03MapPernrData;
import hris.C.rfc.C03EduEntdateRFC;
import hris.common.MappingPernrData;
import hris.common.WebUserData;
import hris.common.rfc.MappingPernrRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.common.Global;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * C03LearnDetailSV.java
 * ����� ���� �̷� ������ ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2001/12/20
 *  [CSR ID:3504688] Global Academy �����̷� I/F ���� ��û
 */
public class C03LearnDetailSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            WebUserData user = WebUtil.getSessionUser(req);

            if(process(req, res, user))
            	printJspPage(req, res, WebUtil.JspURL + "C/C03LearnDetail.jsp");

        } catch (Exception e) {
            throw new GeneralException(e);
        }

    }

	protected boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user) throws GeneralException {
        try{

        	  Box box = WebUtil.getBox(req);

              /**
               * @ marco257
               * ��¥ �ű� �߰� 2015-08-12
               * ���� ���� 3���� �����͸� �⺻���� ǥ��
               */
              String curDate = DataUtil.getCurrentDate();
              String I_BEGDA = box.get("I_BEGDA", WebUtil.printDate(DataUtil.getAfterYear(curDate, -3)));
              String I_ENDDA = box.get("I_ENDDA", WebUtil.printDate(curDate));

             // [CSR ID:3504688] Global Academy �����̷� I/F ���� ��û
              /* C04HrdLearnDetailRFC func1 = new C04HrdLearnDetailRFC();
              Vector<C03LearnDetailData> resultList = func1.getTrainingList(user.empNo, I_BEGDA, I_ENDDA, "", "");*/

              C03LearnDetailDB c03LearnDetailDB=   new C03LearnDetailDB();
              C03MapPernrData c03MapPernrData = new C03MapPernrData();
              c03MapPernrData = getMapPernr(g,  user.empNo,  I_BEGDA);

              Vector<C03LearnDetailData> resultList = c03LearnDetailDB.getTrainingList(c03MapPernrData.PERNR, c03MapPernrData.BEGDA, I_ENDDA);

              req.setAttribute("I_BEGDA", I_BEGDA);
              req.setAttribute("I_ENDDA", I_ENDDA);
              req.setAttribute("resultList", resultList);

              return true;
        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

    public static C03MapPernrData getMapPernr(Global g, String I_PERNR , String I_BEGDA)
    throws GeneralException {

    	MappingPernrRFC mappingPernrRFC = new MappingPernrRFC();
        Vector<MappingPernrData> mapData_vt = null;
        //MappingPernrData mapData = new MappingPernrData();
        C03MapPernrData c03MapPernrData = new C03MapPernrData();

        C03EduEntdateRFC c03EduEntdateRFC = new C03EduEntdateRFC();

        if(g.getSapType().isLocal()) {
            mapData_vt = mappingPernrRFC.getPernr(I_PERNR); //�ش�rfc�� ����sap���� ����
        }else{
        	mapData_vt = new Vector<MappingPernrData>();
        	MappingPernrData mapData = new MappingPernrData();
        	mapData.PERNR = I_PERNR;
        	mapData_vt.add(mapData);
        }


        String entDate = "";
        I_BEGDA =StringUtils.defaultIfEmpty(I_BEGDA,"1900.01.01"); //�λ���ī��� I_BEGDA ���� ����

           for ( int i=0; i < mapData_vt.size(); i++) { // ���Ի���
        	   MappingPernrData mapData = new MappingPernrData();
                mapData = (MappingPernrData)mapData_vt.get(i);
            	/*
            	�����̷� ��ȸ ��������
            	   1-1) �Ի��� ���� �����̷��� �����
            	   1-2)�Ի��� ���� : ������� �̰��ο�-�׷� �Ի���
            	                        �׿� -�ڻ� �Ի���
            	 */
                entDate = WebUtil.printDate(c03EduEntdateRFC.getEduEntDate(mapData.PERNR));
                if(i==0){
                	c03MapPernrData.PERNR = mapData.PERNR;
                	if (I_BEGDA.compareTo( entDate) < 0 ) c03MapPernrData.BEGDA = entDate;
                	else c03MapPernrData.BEGDA = I_BEGDA;

                }else {
                	c03MapPernrData.PERNR = c03MapPernrData.PERNR+","+mapData.PERNR;
                	if (I_BEGDA.compareTo( entDate) < 0 ) c03MapPernrData.BEGDA = c03MapPernrData.BEGDA+","+entDate;
                	else c03MapPernrData.BEGDA = c03MapPernrData.BEGDA+","+I_BEGDA;

                }
             }


        return c03MapPernrData;
}

}
