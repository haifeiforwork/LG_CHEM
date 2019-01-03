package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.A.A12Family.rfc.*;
import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustEduRFC.java
 * �������� - Ư������ ������ ��û/����/��ȸ RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2013/07/01 
 * @version 2.0,  C20140106_63914
 */
public class D11TaxAdjustEducationRFC extends SAPWrap {

	private static String functionName = "ZSOLYR_RFC_YEAR_EDU_N" ;
    /**
     * �������� - Ư������ ������ ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getEdu( String empNo, String targetYear ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function            function = createFunction(functionName) ;
            A12FamilyRelationRFC    func2 = new A12FamilyRelationRFC();         //���� P/E
 
            //A12FamilyScholarshipRFC func  = new A12FamilyScholarshipRFC();      //�з� P/E 
            D11FamilyScholarshipRFC func  = new D11FamilyScholarshipRFC();      //�з� P/E C20140106_63914
            Vector relation_vt            = func2.getFamilyRelation("");
            Vector scholarship_vt         = func.getFamilyScholarship();
            
            setInput(function, empNo, targetYear, "1");
            excute(mConnection, function);
            Vector ret = getOutput(function);

            for( int i = 0 ; i < ret.size() ; i++ ){
                D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)ret.get(i);

                //�����
                for( int j = 0; j < relation_vt.size(); j++ ){
                    CodeEntity entity = (CodeEntity)relation_vt.get(j);
                    
                    if(data.SUBTY.equals(entity.code)){
                        data.STEXT = entity.value;
                        break;
                    }
                }

                //�з¸�
                for( int j = 0; j < scholarship_vt.size(); j++ ){
                    CodeEntity entity = (CodeEntity)scholarship_vt.get(j);
                    
                    if(data.FASAR.equals(entity.code)){
                        data.FATXT = entity.value;
                        break;
                    }
                }
                
                if(data.BETRG.equals("")) { data.BETRG=""; } else{ data.BETRG=Double.toString(Double.parseDouble(data.BETRG)   * 100.0); }  // �ݾ� 

            }
            
            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            //Logger.error(e);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    

    
    /**
     * �������� - Ư������ ������ ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change( String empNo, String targetYear, Vector vec ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            for( int i = 0 ; i < vec.size() ; i++ ){
                D11TaxAdjustDeductData data = (D11TaxAdjustDeductData)vec.get(i);
                if(data.BETRG.equals("")) { data.BETRG=""; } else{ data.BETRG=Double.toString(Double.parseDouble(data.BETRG)   / 100.0); }  // �⺻����
            }
            
            setInput(function, empNo, targetYear, "5");
            setInput(function, vec, "EDUC_T");
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
    private void setInput(JCO.Function function, String empNo, String targetYear, String cont_type) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "P_CONT_TYPE";
        setField( function, fieldName3, cont_type );
        String fieldName4 = "P_FLAG";
        setField( function, fieldName4, "" );
        String fieldName5 = "D_FLAG";
        setField( function, fieldName5, "" );
    }

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
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustDeductData";
        String tableName  = "EDUC_T";
        
        return getTable(entityName, function, tableName);
    }
}