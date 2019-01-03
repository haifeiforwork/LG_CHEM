/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 소속별/직급별 평균근속
*   Program ID   : F06DeptPositionClassServiceRFC
*   Description  : 소속별/직급별 평균근속 조회를 위한 RFC 파일
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F06DeptPositionClassServiceTitleGlobalData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F06DeptPositionClassServiceRFC 부서에 따른 소속별/직급별 평균근속 정보를 가져오는 RFC를 호출하는 Class
 * @author
 * @version 1.0
 */
public class F06DeptPositionClassServiceGlobalRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_OPC_STATE";

	/**
	 * 부서코드에 따른 소속별/직급별 평균근속 정보를 가져오는 RFC를 호출하는 Method
	 * @param java.lang.String 부서코드, 하위여부.
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDeptPositionClassService(String I_ORGEH, String I_LOWERYN, String I_MOLGA)throws GeneralException {

		JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_MOLGA", I_MOLGA);

            excute(mConnection, function);

        	// Table 결과 조회
        	resultList.addElement(getTable(F06DeptPositionClassServiceTitleGlobalData.class,  function, "T_EXPORTA"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}
