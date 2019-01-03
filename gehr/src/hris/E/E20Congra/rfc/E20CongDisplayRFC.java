package hris.E.E20Congra.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;
import hris.E.E20Congra.E20CongcondData;

import java.util.Vector;


/**
 * E20CongDisplayRFC.java
 * 경조금조회 RFC 를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2001/12/18
 * @version v1.1, 2005/11/03 C2005101901000000340 :회수내역추가
 */
public class E20CongDisplayRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_CONGCOND_DISPLAY";
	private String functionName = "ZGHR_RFC_CONGCOND_DISPLAY";

    /**
     * 경조금조회 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongDisplay( SAPType sapType,String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            Vector ret;


            setInput(function, empNo);
            excute(mConnection, function);
            if (!sapType.isLocal())  ret  = getTable(hris.E.E20Congra.Global.E20CongcondData.class, function, "T_RESULT");
            else
            {
            	ret  = getTable(hris.E.E20Congra.E20CongcondData.class, function, "T_RESULT");
                for ( int i = 0 ; i < ret.size() ; i++ ) {
                	E20CongcondData data = (E20CongcondData)ret.get(i);
                	data.WAGE_WONX = Double.toString(Double.parseDouble(data.WAGE_WONX) * 100.0 ) ; //통상임금
                	data.CONG_WONX = Double.toString(Double.parseDouble(data.CONG_WONX) * 100.0 ) ; // 경조금
                	data.RTRO_WONX = Double.toString(Double.parseDouble(data.RTRO_WONX) * 100.0 ) ; // 소급차액
                	data.RFUN_AMNT = Double.toString(Double.parseDouble(data.RFUN_AMNT) * 100.0 ) ; // v1.1지급액
                }
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
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }

}


