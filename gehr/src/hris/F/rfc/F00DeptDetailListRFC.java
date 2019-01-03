/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 인원현황 각각의 상세화면
*   Program ID   : F00DeptDetailListRFC
*   Description  : 인원현황 각각의 상세화면 조회를 위한 RFC 파일
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F00DeptDetailListData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F00DeptDetailListRFC
 * 인원현황 각각의 상세화면 정보를 가져오는 RFC를 호출하는 Class
 * @author
 * @version 1.0
 */
public class F00DeptDetailListRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_DETAIL_STATE";

    /**
     * 인원현황 각각의 상세화면 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptDetailList(String I_STAGB,  String I_ORGEH, String I_LOWERYN, String I_MOLGA,
    								 String I_PARM1, String I_PARM2, String I_PARM3,
									 String I_PARM4, String I_PARM5 ) throws GeneralException {

        JCO.Client mConnection = null;
        Vector resultList = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_STAGB"  , I_STAGB);
            setField(function, "I_ORGEH"  , I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_MOLGA", I_MOLGA);
            setField(function, "I_PARM1"  , I_PARM1);
            setField(function, "I_PARM2"  , I_PARM2);
            setField(function, "I_PARM3"  , I_PARM3);
            setField(function, "I_PARM4"  , I_PARM4);
            setField(function, "I_PARM5"  , I_PARM5);

            excute(mConnection, function);

            // Table 결과 조회
            resultList.addElement(getTable(F00DeptDetailListData.class,  function, "T_EXPORTA"));

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return resultList;
    }
}


