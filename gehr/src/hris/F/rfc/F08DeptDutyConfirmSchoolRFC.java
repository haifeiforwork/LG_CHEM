/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 직무별/인정학력별
*   Program ID   : F08DeptDutyConfirmSchoolRFC
*   Description  : 직무별/인정학력별 조회를 위한 RFC 파일
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F08DeptDutySchoolNoteData;
import hris.F.F08DeptDutySchoolTitleData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F08DeptDutyConfirmSchoolRFC
 * 부서에 따른 직무별/인정학력별 정보를 가져오는 RFC를 호출하는 Class
 * @author
 * @version 1.0
 */
public class F08DeptDutyConfirmSchoolRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_JSV_STATE";

    /**
     * 부서코드에 따른 직무별/인정학력별 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptDutyConfirmSchool(String I_ORGEH, String I_LOWERYN, String I_MOLGA) throws GeneralException {

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
        	resultList.addElement(getTable(F08DeptDutySchoolTitleData.class,  function, "T_EXPORTA"));
        	resultList.addElement(getTable(F08DeptDutySchoolNoteData.class,  function, "T_EXPORTB"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


