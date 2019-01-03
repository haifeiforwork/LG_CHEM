package hris.E.E11Personal.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E11Personal.*;

/**
 * E11PersonalDetailRFC.java
 * ���ο��� / ���̶������� ��ȸ�ϴ� RFC �� ȣ���ϴ� Class                        
 *
 * @author �ڿ���
 * @version 1.0, 2002/02/01
 */
public class E11PersonalDetailRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_PENTION_DISPLAY";

    /**
     * ���ο��� / ���̶������� ��ȸ ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getDetail( String empNo, String type, String begda ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            E11PersonalDivisionNameRFC func  = new E11PersonalDivisionNameRFC();
            E11PersonalInsureRFC       func2 = new E11PersonalInsureRFC();       //���Ժ����
            
            Vector divisionName_vt           = func.getName();
            Vector insure_vt                 = func2.getInsure();
            String date = DataUtil.getCurrentDate();//���糯¥�� �����´�.
            
            setInput( function, empNo, type, begda );
            excute(mConnection, function);
            
            Vector ret = getOutput(function);
            for( int p = 0 ; p < ret.size() ; p++ ) {
                E11PersonalData data = (E11PersonalData)ret.get(p);
                
                for( int i = 0; i < divisionName_vt.size(); i++ ){
                    CodeEntity entity = (CodeEntity)divisionName_vt.get(i);
                    
Logger.debug.println(this, "########## data.PENT_TYPE : " + data.PENT_TYPE + " // entity.code : " + entity.code);
                    
                    if( ( data.PENT_TYPE ).equals( entity.code ) ){
                        data.PENT_TEXT = entity.value;
Logger.debug.println(this, "########## data.PENT_TEXT : " + data.PENT_TEXT + " // break!!! ");
                        break;
                    }
                }
                for( int k = 0; k < insure_vt.size(); k++ ){
                    CodeEntity entity = (CodeEntity)insure_vt.get(k);
                    if( ( data.BANK_TYPE ).equals( entity.code ) ){
                        data.BANK_TEXT = entity.value;
                        break;
                    }
                }
                if( !(data.CMPY_DATE).equals(data.ENDDA) ){
                    data.STATUS = "�ؾ�";
                    data.ABDN_DATE = data.ENDDA;      //������ ����
                } else {
                    Logger.debug.println( this, date + ".compareTo("+data.CMPY_TOXX+") = " + date.compareTo( data.CMPY_TOXX ) );
                    if( date.compareTo( DataUtil.removeStructur(data.CMPY_TOXX, "-") ) > 0 ){
                        data.STATUS = "����";
                    } else {
                        data.STATUS = "������";
                    }
                }
            }

Logger.debug.println(this, "########## ret : " + ret);

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
    private void setInput(JCO.Function function, String empNo, String type, String begda ) throws GeneralException {
        String fieldName = "PERNR";
        setField( function, fieldName, empNo );
        String fieldName1 = "PENT_TYPE";
        setField( function, fieldName1, type );
        String fieldName2 = "BEGDA";
        setField( function, fieldName2, begda );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E11Personal.E11PersonalData";
        String tableName  = "IT";
        Vector ret        = getTable(entityName, function, tableName);//���Ͱ� �������ϰ��?
        
        Logger.debug.println(this, "vectorsize : "+ret.size() );

        for( int i = 0 ; i < ret.size() ; i++ ) {
            E11PersonalData data = (E11PersonalData)ret.get(i);
            data.SUMM_AMNT  = getField("SUMM_AMNT", function );   
            data.LAST_MNTH  = getField("LAST_MNTH", function );   //���氡�� - �ܿ�����
            //data.CMPY_DATE  = getField("CMPY_DATE", function );   //ȸ�������ѵ���
            data.MNTH_AMNT = Double.toString(Double.parseDouble(data.MNTH_AMNT) * 100.0 );
            data.PERL_AMNT = Double.toString(Double.parseDouble(data.PERL_AMNT) * 100.0 );
            data.CMPY_AMNT = Double.toString(Double.parseDouble(data.CMPY_AMNT) * 100.0 );
            data.SUMM_AMNT = Double.toString(Double.parseDouble(data.SUMM_AMNT) * 100.0 );
        }

        return ret;
    }

}
