/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 연명부
*   Program ID   : F21DeptEntireEmpInfoRFC.java
*   Description  : 부서별 연명부 검색을 위한 RFC 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F.rfc;

import hris.A.A01SelfDetailData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * F21DeptEntireEmpInfoRFC.java
 * 부서에 따른 전체 부서원의 연명부를 가져오는 RFC를 호출하는 Class
 * @author
 * @version
 */
public class F21DeptEntireEmpInfoRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_ORG_PERSON_INFO";

    /**
     * 부서코드에 따른 전체 부서원의 연명부를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptEntireEmpList(String I_ORGEH, String I_LOWERYN, boolean userArea) throws GeneralException {

        JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);

            excute(mConnection, function);

            Class classPath = null;

            //if( userArea ) classPath = F21DeptEntireEmpInfoData.class;
            //else  classPath= F21DeptEntireEmpInfoGlobalData.class;
            // Table 결과 조회
        	resultList.addElement(getTable(A01SelfDetailData.class,  function, "T_EXPORTA"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


