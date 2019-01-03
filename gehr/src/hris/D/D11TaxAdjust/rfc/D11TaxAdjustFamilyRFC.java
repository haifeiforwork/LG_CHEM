package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ; 
import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustFamilyRFC.java
 * �������� - �ξ簡������ ��ȸ RFC�� ȣ���ϴ� Class
 *
 * @author l sa
 * @version 1.0, 2005/11/24
 * @version 1.0, 2013/12/10 CSR ID:C20140106_63914 ���߱���  �߰� 
 */
public class D11TaxAdjustFamilyRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_YEAR_FAMILY" ;

    /**
     * �������� - �ξ簡������ ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFamily( String empNo, String targetYear,String Gubun ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, targetYear, "1");
            excute(mConnection, function);
            Vector ret =  new Vector();
            if ( Gubun.equals("1") ) {
                ret = getOutput1(function);
            }else if ( Gubun.equals("") )  {
                ret = getOutput(function);
            }

//          �������� ������ �߰��Ѵ�.
            D11TaxAdjustPersonRFC rfc01 = new D11TaxAdjustPersonRFC();
            Vector person_vt = new Vector();
            int    inx = 0;
            person_vt = rfc01.getPerson( empNo, targetYear );
            for( int i = 0 ; i < ret.size() ; i++ ){
                D11TaxAdjustFamilyData data = (D11TaxAdjustFamilyData)ret.get(i);
            
                if( !data.FAMI_REGN.equals("") ) {
                     for( int j = 0 ; j < person_vt.size() ; j++ ) {
                         D11TaxAdjustPersonData person_data = (D11TaxAdjustPersonData)person_vt.get(j);
                         
                         if( data.FAMI_REGN.equals(person_data.REGNO) ) {
                             if(person_data.BETRG01.equals("0.0")){ data.FAMI_B001=""; }else{ data.FAMI_B001="X"; }  // �⺻����
                             if(person_data.BETRG03.equals("0.0")){ data.FAMI_B002=""; }else{ data.FAMI_B002="X"; }  // �����
                             if(person_data.BETRG05.equals("0.0")){ data.FAMI_B003=""; }else{ data.FAMI_B003="X"; }  // �ڳ������
                             inx++;
                         }
                     }
                }
                if ( inx == 0 ) {
                    data.FAMI_B001=""; 
                    data.FAMI_B002=""; 
                    data.FAMI_B003="";                	
                } 

                if(data.INSUR.equals("")) { data.INSUR =""; }else{ data.INSUR =Double.toString(Double.parseDouble(data.INSUR ) * 100.0); }  // �����     
                if(data.MEDIC.equals("")) { data.MEDIC =""; }else{ data.MEDIC =Double.toString(Double.parseDouble(data.MEDIC ) * 100.0); }  // �Ƿ��     
                if(data.EDUCA.equals("")) { data.EDUCA =""; }else{ data.EDUCA =Double.toString(Double.parseDouble(data.EDUCA ) * 100.0); }  // ������     
                if(data.CREDIT.equals("")){ data.CREDIT=""; }else{ data.CREDIT=Double.toString(Double.parseDouble(data.CREDIT) * 100.0); }  // �ſ�ī��   
                if(data.CASHR.equals("")) { data.CASHR =""; }else{ data.CASHR =Double.toString(Double.parseDouble(data.CASHR ) * 100.0); }  // ���ݿ����� 
                if(data.GIBU.equals(""))  { data.GIBU  =""; }else{ data.GIBU  =Double.toString(Double.parseDouble(data.GIBU  ) * 100.0); }  // ��α�     
                if(data.DEBIT.equals(""))  { data.DEBIT  =""; }else{ data.DEBIT  =Double.toString(Double.parseDouble(data.DEBIT  ) * 100.0); }  // ����ī���     
                if(data.CCREDIT.equals(""))  { data.CCREDIT  =""; }else{ data.CCREDIT  =Double.toString(Double.parseDouble(data.CCREDIT  ) * 100.0); }  //C20121213_34842 ����������   
                if(data.PCREDIT.equals(""))  { data.PCREDIT  =""; }else{ data.PCREDIT  =Double.toString(Double.parseDouble(data.PCREDIT  ) * 100.0); }  //C20140106_63914 ���߱������       
           
            }

            return ret;

        } catch(GeneralException gex){
            // NO_DATA_FOUND ������ ����͸� ���� Object�� �����Ѵ�.com.sap.mw.jco.JCO$AbapException
            String exMsg = "com.sap.mw.jco.JCO$AbapException: (126) NO_DATA_FOUND: �ش� ���ڿ� INFOTYPE ���� ����";
            StackTraceElement[] stackTraceBuffer = gex.getStackTrace();
          
            if( exMsg.equals(stackTraceBuffer.toString( )) ){
                Vector ret = new Vector();
                return ret;
            } else {
                throw new GeneralException(gex);
            }
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * �������� - �ξ簡������ �Է� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String empNo, String targetYear, Vector person_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, targetYear, "5");

            setInput(function, person_vt, "RESULT");

            excute(mConnection, function);

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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String targetYear, String conftype) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3, "" );
        String fieldName4 = "I_ENDDA";
        setField( function, fieldName4, "" );
        String fieldName5 = "P_CONF_TYPE";
        setField( function, fieldName5, conftype );
    }

    // Import Parameter �� Vector(Table) �� ���
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustFamilyData";
        String tableName  = "RESULT";

        return getTable(entityName, function, tableName);
    }
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustFamilyData";
        String tableName  = "RESULT1";

        return getTable(entityName, function, tableName);
    }
}