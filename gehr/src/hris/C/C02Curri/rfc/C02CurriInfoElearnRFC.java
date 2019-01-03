package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriInfoElearnRFC.java
 * e-learning �ý��ۿ��� �Ѱ��� OBJID�� �̺�ƮID�� ������ ���Ѵ�.
 *
 * @author �赵��
 * @version 1.0, 2002/10/09
 */
public class C02CurriInfoElearnRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EVENT_INFORMATION_E";

    /**
     * ���� �������� ���븦 �������� RFC�� ȣ���ϴ� Method
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
                        data.STATE="������";
                    } else if( (data.BEGDA).compareTo(newDate) <= 0 && (data.ENDDA).compareTo(newDate) >= 0 ){
                        data.STATE="�ǽ���";
                    } else {
                        data.STATE="����";
                    }
                } else {
                    if( (data.SDATE).compareTo(newDate) > 0 ){
                        data.STATE="������";
                    } else if( (data.EDATE).compareTo(newDate) < 0 && (data.BEGDA).compareTo(newDate) > 0 ){
                        data.STATE="�����Ϸ�";
                    } else if( (data.BEGDA).compareTo(newDate) <= 0 && (data.ENDDA).compareTo(newDate) >= 0 ){
                        data.STATE="�ǽ���";
                    } else if( (data.ENDDA).compareTo(newDate) < 0 ){
                        data.STATE="����";
                    } else {
                        data.STATE="������";
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param java.lang.String OBJID ������ƮID
     * @param java.lang.String SOBID ���ÿ�����ƮID
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key) throws GeneralException{
        String fieldName = "I_OBJID";
        setField(function, fieldName, key);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
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
