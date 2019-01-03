/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 포상/징계 내역
*   Program ID   : F27DeptRewardNPunishRFC
*   Description  : 부서별 포상/징계 내역 조회를 위한 RFC 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F.rfc;

import hris.F.F26DeptExperiencedEmpData;
import hris.F.F26DeptExperiencedEmpGlobalData;
import hris.F.F27DeptRewardNPunish01Data;
import hris.F.F27DeptRewardNPunish01GlobalData;
import hris.F.F27DeptRewardNPunish02Data;
import hris.F.F27DeptRewardNPunish02GlobalData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F27DeptRewardNPunishRFC
 * 부서에 따른 전체 부서원의 포상/징계 내역 정보를 가져오는 RFC를 호출하는 Class
 * @author
 * @version 1.0
 */
public class F27DeptRewardNPunishRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_ORG_PR_PU_INFO";

    /**
     * 부서코드에 따른 전체 부서원의 포상/징계 내역 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptRewardNPunish(String I_ORGEH, String I_LOWERYN, boolean userArea) throws GeneralException {

        JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);

            excute(mConnection, function);

            Class classPathA = null;
            Class classPathB = null;

            if( userArea ){
            	classPathA = F27DeptRewardNPunish01Data.class;
            	classPathB = F27DeptRewardNPunish02Data.class;
            }else{
            	classPathA = F27DeptRewardNPunish01GlobalData.class;
            	classPathB = F27DeptRewardNPunish02GlobalData.class;
            }

        	resultList.addElement(getTable(classPathA,  function, "T_EXPORTA"));
        	resultList.addElement(getTable(classPathB,  function, "T_EXPORTB"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


