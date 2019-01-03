package hris.D.D03Vocation.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.D.D03Vocation.*;

/**
 * D03CondolHolidaysRFC.java
 * ����������ȸ RFC �� ȣ���ϴ� Class                        
 *
 * @author lsa
 * @version 1.0, 2008/03/11
 */
public class D03CondolHolidaysRFC extends SAPWrap {

//    private String functionName = "ZHRW_RFC_GET_CONDOL_HOLIDAYS";
    private String functionName = "ZGHR_RFC_GET_CONDOL_HOLIDAYS";

    /**
     * ��������ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongDisplay( String empNo,String P_CONT_TYPE,String P_BEGDA,String P_A002_SEQN,String P_A024_SEQN ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,P_CONT_TYPE,P_BEGDA,P_A002_SEQN,P_A024_SEQN);
            excute(mConnection, function);
            Vector ret =  getTable(hris.D.D03Vocation.D03CondolHolidaysData.class, function, "T_RESULT"); //P_RESULT

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo,String P_CONT_TYPE,String P_BEGDA,String P_A002_SEQN,String P_A024_SEQN) throws GeneralException {
        String fieldName1 = "I_ITPNR";//P_PERNR
        String fieldName2 = "I_GTYPE";//P_CONT_TYPE
        String fieldName3 = "I_BEGDA";//P_
        String fieldName4 = "I_A002_SEQN"; //P_
        String fieldName5 = "I_A024_SEQN";//P_
        setField( function, fieldName1, empNo );
        setField( function, fieldName2, P_CONT_TYPE );   
        setField( function, fieldName3, P_BEGDA );   
        setField( function, fieldName4, P_A002_SEQN );   
        setField( function, fieldName5, P_A024_SEQN );        
    }

}


