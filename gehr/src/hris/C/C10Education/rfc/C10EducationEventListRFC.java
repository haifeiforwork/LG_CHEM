package hris.C.C10Education.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C10Education.*;

/**
 * C10EducationEventListRFC.java
 * 교육 차수 list를 읽는다.
 *
 * @author  김도신
 * @version 1.0, 2005/05/28
 */
public class C10EducationEventListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EDUCATION_EVENT_LIST";

    /**
     * @param i_objid java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getList( String i_objid ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_objid);
            excute(mConnection, function);

            Vector ret = getOutput(function);

//          교육 차수의 상태 정보 설정
            String newDate = WebUtil.printDate( DataUtil.getCurrentDate(), "-" );
            for ( int i = 0 ; i < ret.size() ; i++ ){
                C10EducationEventListData data = (C10EducationEventListData)ret.get(i);
                if( data.SDATE.equals("0000-00-00") ||data.SDATE.equals("")){
                    if( (data.BEGDA).compareTo(newDate) > 0 ){
                        data.STATE="접수전";
                    } else if( (data.BEGDA).compareTo(newDate) <= 0 && (data.ENDDA).compareTo(newDate) >= 0 ){
                        data.STATE="실시중";
                    } else {
                        data.STATE="종료";
                    }
                } else {
                    if( (data.SDATE).compareTo(newDate) > 0 ){
                        data.STATE="접수전";
                    } else if( (data.EDATE).compareTo(newDate) < 0 && (data.BEGDA).compareTo(newDate) > 0 ){
                        data.STATE="접수완료";
                    } else if( (data.BEGDA).compareTo(newDate) <= 0 && (data.ENDDA).compareTo(newDate) >= 0 ){
                        data.STATE="실시중";
                    } else if( (data.ENDDA).compareTo(newDate) < 0 ){
                        data.STATE="종료";
                    } else {
                        data.STATE="접수중";
                    }
                }
                data.IKOST = Double.toString(Double.parseDouble( data.IKOST ) * 100.0 );
            }

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
     * @param i_objid java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_objid) throws GeneralException {
        String fieldName = "I_OBJID";
        setField( function, fieldName, i_objid );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C10Education.C10EducationEventListData";
        
        return getTable(entityName, function, "T_RESULT2");
    }
}


