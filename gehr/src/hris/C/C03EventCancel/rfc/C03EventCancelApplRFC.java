package hris.C.C03EventCancel.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*; 
import com.sap.mw.jco.*; 
import hris.C.C03EventCancel.*;


/**
 * C03EventCancelApplRFC.java
 * 교육과정 취소신청 조회/신청/수정/삭제 RFC 를 호출하는 Class                        
 *
 * @author lsa
 * @version 1.0, 2013/06/15 교육취소신청 결재 추가 | [요청번호]C20130627_58399
 */
public class C03EventCancelApplRFC extends SAPWrap {

    private String functionName = "ZHRD_RFC_EVENT_CANCLE_APPROVAL";

    /**
     * 교육과정 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @param  java.lang.String 사원번호
	 * @param  java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail( String ainfSeqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, ainfSeqn, "1");
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
 
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
	 * @param java.lang.String 사원번호
     * @param java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key, String job) throws GeneralException {
        String fieldName = "P_AINF_SEQN";
        setField( function, fieldName, key );
        String fieldName1 = "P_CONF_TYPE";
        setField( function, fieldName1, job );

    }
 
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @param tableName java.util.Vector
     * @param prev java.lang.String
     * @exception com.sns.jdf.GeneralException
     */

    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C03EventCancel.C03EventCancelData";
        Vector  ret = getTable(entityName, function, "P_EVENT");
        return ret ;
    }
}


