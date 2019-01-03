package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriInfoElearnRFC.java
 * e-learning 시스템에서 넘겨진 OBJID로 이벤트ID와 정보를 구한다.
 *
 * @author 김도신
 * @version 1.0, 2002/10/09
 */
public class C02CurriInfoElearnRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EVENT_INFORMATION_E";

    /**
     * 세부 교육과정 내용를 가져오는 RFC를 호출하는 Method
     * @param java.lang.Object hris.C.C02Curri.C02CurriInfoData Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getEventInfo( String OBJID ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, OBJID );
            excute(mConnection, function);
            Vector ret = getOutput(function);
            String newDate = WebUtil.printDate( DataUtil.getCurrentDate(), "-" );
            Logger.debug.println( this, "newDate : "+newDate );
            
            if( ret.size() > 0 ) {
                C02CurriInfoData data = (C02CurriInfoData)ret.get(0);
                if( data.SDATE.equals("0000-00-00")||data.SDATE.equals("") ){
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

        } catch(Exception ex) {
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
     * @param java.lang.String OBJID 오브젝트ID
     * @param java.lang.String SOBID 관련오브젝트ID
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key) throws GeneralException{
        String fieldName = "I_OBJID";
        setField(function, fieldName, key);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C02Curri.C02CurriInfoData";
        String tableName  = "P_EDU_INFORM";
        return getTable(entityName, function, tableName);
    }
}
