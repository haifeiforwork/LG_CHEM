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
 * 사원의 교육 이력 사항을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2001/12/20
 *  [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청
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
               * 날짜 신규 추가 2015-08-12
               * 현재 부터 3년전 데이터를 기본으로 표시
               */
              String curDate = DataUtil.getCurrentDate();
              String I_BEGDA = box.get("I_BEGDA", WebUtil.printDate(DataUtil.getAfterYear(curDate, -3)));
              String I_ENDDA = box.get("I_ENDDA", WebUtil.printDate(curDate));

             // [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청
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
            mapData_vt = mappingPernrRFC.getPernr(I_PERNR); //해당rfc는 국내sap에만 있음
        }else{
        	mapData_vt = new Vector<MappingPernrData>();
        	MappingPernrData mapData = new MappingPernrData();
        	mapData.PERNR = I_PERNR;
        	mapData_vt.add(mapData);
        }


        String entDate = "";
        I_BEGDA =StringUtils.defaultIfEmpty(I_BEGDA,"1900.01.01"); //인사기록카드는 I_BEGDA 값이 없음

           for ( int i=0; i < mapData_vt.size(); i++) { // 재입사자
        	   MappingPernrData mapData = new MappingPernrData();
                mapData = (MappingPernrData)mapData_vt.get(i);
            	/*
            	교육이력 조회 기준일자
            	   1-1) 입사일 이후 교육이력이 대상임
            	   1-2)입사일 기준 : 생명과학 이관인원-그룹 입사일
            	                        그외 -자사 입사일
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
