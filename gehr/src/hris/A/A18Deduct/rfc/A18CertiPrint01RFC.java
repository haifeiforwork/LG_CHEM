package hris.A.A18Deduct.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.A.A18Deduct.* ;
import hris.D.D11TaxAdjust.D11TaxAdjustPreWorkData;

/**
 *  A18CertiPrint01RFC.java
 *  �ٷμҵ��õ¡��������:T_RESULT�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2005/09/29
 */
public class A18CertiPrint01RFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_READ_YEA_RESULT_PRINT" ;

    /**
     * �������� ��������� �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);
            
            return getOutput( function );
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
     * @param empNo java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
    }
// Export Return type�� Vector �� ��� �� Vector�� Element type �� com.sns.jdf.util.CodeEntity �� ��� 2
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

//      Table ��ȸ
        String entityName      = "hris.A.A18Deduct.A18CertiPrintPreWorkData";
        Vector T_PREWORK       = getTable(entityName,  function, "T_PREWORK");
        String entityName2     = "hris.A.A18Deduct.A18CertiPrintBusiData";
        Vector T_BUSINESSPLACE = getTable(entityName2, function, "T_BUSINESSPLACE");

        String tableName       = "T_RESULT";   // RFC Export ������� ����
        String codeField       = "LGART";      // RFC Export table�� field ������� �� CodeEntity�� "code" �� �� Field Name 
        String valueField      = "BETRG";      // RFC Export table�� field ������� �� CodeEntity�� "value" �� �� Field Name 
        Vector T_RESULT        = getCodeVector( function, tableName, codeField, valueField );
        
        //A18CertiPrintPreWorkData dataPre = new A18CertiPrintPreWorkData();
        //if( T_PREWORK.size()       > 0 )
        //{     dataPre = (A18CertiPrintPreWorkData)T_PREWORK.get(0); 

        for( int i = 0 ; i < T_PREWORK.size() ; i++ ){
        	A18CertiPrintPreWorkData dataPre = (A18CertiPrintPreWorkData)T_PREWORK.get(i);        
		        if(dataPre.BET01.equals("")){ dataPre.BET01=""; }else{ dataPre.BET01=Double.toString(Double.parseDouble(dataPre.BET01) * 100.0); }  // �ݾ�
		        if(dataPre.BET02.equals("")){ dataPre.BET02=""; }else{ dataPre.BET02=Double.toString(Double.parseDouble(dataPre.BET02) * 100.0); }  // �ݾ�
		        if(dataPre.BET03.equals("")){ dataPre.BET03=""; }else{ dataPre.BET03=Double.toString(Double.parseDouble(dataPre.BET03) * 100.0); }  // �ݾ�
		        if(dataPre.BET04.equals("")){ dataPre.BET04=""; }else{ dataPre.BET04=Double.toString(Double.parseDouble(dataPre.BET04) * 100.0); }  // �ݾ�
		        if(dataPre.BET05.equals("")){ dataPre.BET05=""; }else{ dataPre.BET05=Double.toString(Double.parseDouble(dataPre.BET05) * 100.0); }  // �ݾ�
		        if(dataPre.BET06.equals("")){ dataPre.BET06=""; }else{ dataPre.BET06=Double.toString(Double.parseDouble(dataPre.BET06) * 100.0); }  // �ݾ�
		        if(dataPre.BET07.equals("")){ dataPre.BET07=""; }else{ dataPre.BET07=Double.toString(Double.parseDouble(dataPre.BET07) * 100.0); }  // �ݾ�
		        if(dataPre.BET08.equals("")){ dataPre.BET08=""; }else{ dataPre.BET08=Double.toString(Double.parseDouble(dataPre.BET08) * 100.0); }  // �ݾ�
		        if(dataPre.BET09.equals("")){ dataPre.BET09=""; }else{ dataPre.BET09=Double.toString(Double.parseDouble(dataPre.BET09) * 100.0); }  // �ݾ�
		        if(dataPre.BET10.equals("")){ dataPre.BET10=""; }else{ dataPre.BET10=Double.toString(Double.parseDouble(dataPre.BET10) * 100.0); }  // �ݾ�
		        if(dataPre.BET11.equals("")){ dataPre.BET11=""; }else{ dataPre.BET11=Double.toString(Double.parseDouble(dataPre.BET11) * 100.0); }  // �ݾ�
		        if(dataPre.BET12.equals("")){ dataPre.BET12=""; }else{ dataPre.BET12=Double.toString(Double.parseDouble(dataPre.BET12) * 100.0); }  // �ݾ�
		        if(dataPre.BET13.equals("")){ dataPre.BET13=""; }else{ dataPre.BET13=Double.toString(Double.parseDouble(dataPre.BET13) * 100.0); }  // �ݾ�
		        if(dataPre.BET14.equals("")){ dataPre.BET14=""; }else{ dataPre.BET14=Double.toString(Double.parseDouble(dataPre.BET14) * 100.0); }  // �ݾ�
		        if(dataPre.BET15.equals("")){ dataPre.BET15=""; }else{ dataPre.BET15=Double.toString(Double.parseDouble(dataPre.BET15) * 100.0); }  // �ݾ�
		        if(dataPre.BET16.equals("")){ dataPre.BET16=""; }else{ dataPre.BET16=Double.toString(Double.parseDouble(dataPre.BET16) * 100.0); }  // �ݾ�
		        if(dataPre.BET17.equals("")){ dataPre.BET17=""; }else{ dataPre.BET17=Double.toString(Double.parseDouble(dataPre.BET17) * 100.0); }  // �ݾ�
		        if(dataPre.BET18.equals("")){ dataPre.BET18=""; }else{ dataPre.BET18=Double.toString(Double.parseDouble(dataPre.BET18) * 100.0); }  // �ݾ�
		        if(dataPre.BET19.equals("")){ dataPre.BET19=""; }else{ dataPre.BET19=Double.toString(Double.parseDouble(dataPre.BET19) * 100.0); }  // �ݾ�
		        if(dataPre.BET20.equals("")){ dataPre.BET20=""; }else{ dataPre.BET20=Double.toString(Double.parseDouble(dataPre.BET20) * 100.0); }  // �ݾ�
		        if(dataPre.BET21.equals("")){ dataPre.BET21=""; }else{ dataPre.BET21=Double.toString(Double.parseDouble(dataPre.BET21) * 100.0); }  // �ݾ�
		        if(dataPre.BET22.equals("")){ dataPre.BET22=""; }else{ dataPre.BET22=Double.toString(Double.parseDouble(dataPre.BET22) * 100.0); }  // �ݾ�
		        if(dataPre.BET23.equals("")){ dataPre.BET23=""; }else{ dataPre.BET23=Double.toString(Double.parseDouble(dataPre.BET23) * 100.0); }  // �ݾ�
		        if(dataPre.BET24.equals("")){ dataPre.BET24=""; }else{ dataPre.BET24=Double.toString(Double.parseDouble(dataPre.BET24) * 100.0); }  // �ݾ�
		        if(dataPre.BET25.equals("")){ dataPre.BET25=""; }else{ dataPre.BET25=Double.toString(Double.parseDouble(dataPre.BET25) * 100.0); }  // �ݾ�
		        if(dataPre.BET26.equals("")){ dataPre.BET26=""; }else{ dataPre.BET26=Double.toString(Double.parseDouble(dataPre.BET26) * 100.0); }  // �ݾ�
		        if(dataPre.BET27.equals("")){ dataPre.BET27=""; }else{ dataPre.BET27=Double.toString(Double.parseDouble(dataPre.BET27) * 100.0); }  // �ݾ�
		        if(dataPre.BET28.equals("")){ dataPre.BET28=""; }else{ dataPre.BET28=Double.toString(Double.parseDouble(dataPre.BET28) * 100.0); }  // �ݾ�
		        if(dataPre.BET29.equals("")){ dataPre.BET29=""; }else{ dataPre.BET29=Double.toString(Double.parseDouble(dataPre.BET29) * 100.0); }  // �ݾ�
		        if(dataPre.BET30.equals("")){ dataPre.BET30=""; }else{ dataPre.BET30=Double.toString(Double.parseDouble(dataPre.BET30) * 100.0); }  // �ݾ�
		        if(dataPre.BET31.equals("")){ dataPre.BET31=""; }else{ dataPre.BET31=Double.toString(Double.parseDouble(dataPre.BET31) * 100.0); }  // �ݾ�
		        if(dataPre.BET32.equals("")){ dataPre.BET32=""; }else{ dataPre.BET32=Double.toString(Double.parseDouble(dataPre.BET32) * 100.0); }  // �ݾ�
		        if(dataPre.BET33.equals("")){ dataPre.BET33=""; }else{ dataPre.BET33=Double.toString(Double.parseDouble(dataPre.BET33) * 100.0); }  // �ݾ�
		        if(dataPre.BET34.equals("")){ dataPre.BET34=""; }else{ dataPre.BET34=Double.toString(Double.parseDouble(dataPre.BET34) * 100.0); }  // �ݾ�
		        if(dataPre.BET35.equals("")){ dataPre.BET35=""; }else{ dataPre.BET35=Double.toString(Double.parseDouble(dataPre.BET35) * 100.0); }  // �ݾ�
		        if(dataPre.BET36.equals("")){ dataPre.BET36=""; }else{ dataPre.BET36=Double.toString(Double.parseDouble(dataPre.BET36) * 100.0); }  // �ݾ�
		        if(dataPre.BET37.equals("")){ dataPre.BET37=""; }else{ dataPre.BET37=Double.toString(Double.parseDouble(dataPre.BET37) * 100.0); }  // �ݾ�
		        if(dataPre.BET38.equals("")){ dataPre.BET38=""; }else{ dataPre.BET38=Double.toString(Double.parseDouble(dataPre.BET38) * 100.0); }  // �ݾ�
		        if(dataPre.BET39.equals("")){ dataPre.BET39=""; }else{ dataPre.BET39=Double.toString(Double.parseDouble(dataPre.BET39) * 100.0); }  // �ݾ�
		        if(dataPre.BET40.equals("")){ dataPre.BET40=""; }else{ dataPre.BET40=Double.toString(Double.parseDouble(dataPre.BET40) * 100.0); }  // �ݾ�
		        if(dataPre.BET41.equals("")){ dataPre.BET41=""; }else{ dataPre.BET41=Double.toString(Double.parseDouble(dataPre.BET41) * 100.0); }  // �ݾ�
		        if(dataPre.BET42.equals("")){ dataPre.BET42=""; }else{ dataPre.BET42=Double.toString(Double.parseDouble(dataPre.BET42) * 100.0); }  // �ݾ�
		        if(dataPre.BET43.equals("")){ dataPre.BET43=""; }else{ dataPre.BET43=Double.toString(Double.parseDouble(dataPre.BET43) * 100.0); }  // �ݾ�
		        if(dataPre.BET44.equals("")){ dataPre.BET44=""; }else{ dataPre.BET44=Double.toString(Double.parseDouble(dataPre.BET44) * 100.0); }  // �ݾ�
		        if(dataPre.BET45.equals("")){ dataPre.BET45=""; }else{ dataPre.BET45=Double.toString(Double.parseDouble(dataPre.BET45) * 100.0); }  // �ݾ�                  
/*	          dataPre.SAL01 = Double.toString(Double.parseDouble(dataPre.SAL01) * 100.0);          // �����ٹ����� ���Ա޿� 
	          dataPre.BON01 = Double.toString(Double.parseDouble(dataPre.BON01) * 100.0);          // �����ٹ����� ��   
	          dataPre.ABN01 = Double.toString(Double.parseDouble(dataPre.ABN01) * 100.0);          // �����ٹ����� Ȯ�λ�   
	          dataPre.STK01 = Double.toString(Double.parseDouble(dataPre.STK01) * 100.0);          // �����ٹ����� ���� �ɼ�   
	          dataPre.SAL02 = Double.toString(Double.parseDouble(dataPre.SAL02) * 100.0);          // �����ٹ����� ���Ա޿� 
	          dataPre.BON02 = Double.toString(Double.parseDouble(dataPre.BON02) * 100.0);          // �����ٹ����� ��   
	          dataPre.ABN02 = Double.toString(Double.parseDouble(dataPre.ABN02) * 100.0);          // �����ٹ����� Ȯ�λ�   
	          dataPre.STK02 = Double.toString(Double.parseDouble(dataPre.STK02) * 100.0);          // �����ٹ����� ���� �ɼ�   
              */
        }
        A18CertiPrintBusiData    dataBus = new A18CertiPrintBusiData();
        if( T_BUSINESSPLACE.size() > 0 ) {     dataBus = (A18CertiPrintBusiData)T_BUSINESSPLACE.get(0);     }
        
        A18CertiPrint01Data data = (A18CertiPrint01Data)matchData(T_RESULT);

//      Export ���� ��ȸ
        String fieldName = "E_PERIOD" ;
        String E_PERIOD  = getField(fieldName, function);

       // ret.addElement(dataPre);
        ret.addElement(T_PREWORK);
        ret.addElement(dataBus);
        ret.addElement(data);
        ret.addElement(E_PERIOD);

        String entityName3     = "hris.A.A18Deduct.A18CertiPrintPreWorkNmData";
        Vector T_LGART_LIST = getTable(entityName3, function, "T_LGART_LIST");
        ret.addElement(T_LGART_LIST);
        return ret;
    }

//  
    private Object matchData(Vector ret) throws GeneralException {
        A18CertiPrint01Data retData = new A18CertiPrint01Data();

        double _�ֽĸż����ñ������������ = 0 ; // "/P18"
        double _�ֽĸż����ñ������������ = 0  ; // "/Y18"
        double _������ҵ�_�߰��ٷμ������� = 0 ; // "/P06"
        double _������ҵ�_�߰��ٷμ������� = 0  ; // "/Y1E"
         
        for( int i = 0 ; i < ret.size() ; i++ ) {
            CodeEntity data = (CodeEntity)ret.get(i);
            double d_value = 0;
            
            if(data.value.equals("")) {
              d_value = 0;
            } else { 
              d_value = Double.parseDouble(data.value) * 100.0;          // 100�� ���ؼ� ��ȯ���ش�. 
            }

            if(data.code.equals("/P03")){           // �޿��Ѿ�
                retData._����_�ҵ漼 = d_value; 
            } else if(data.code.equals("/P04")){           // �޿��Ѿ�
                retData._����_�ֹμ� = d_value; 
            } else if(data.code.equals("/Y1A")){           // �޿��Ѿ�
                retData._�޿��Ѿ� = d_value; 
            } else if(data.code.equals("/Y1B")){    // ���Ѿ�
                retData._���Ѿ� = d_value; 
            } else if(data.code.equals("/Y1C")){    // ������
                retData._������ = d_value; 
            } else if(data.code.equals("/Y18")){    // �ֽĸż����ñ�������� 09.02.03 add   
                _�ֽĸż����ñ������������ = d_value; 
            } else if(data.code.equals("/P18")){    // �ֽĸż����ñ������������ 10.02.03 add   
                _�ֽĸż����ñ������������ = d_value; 
            } else if(data.code.equals("/Y22")){    // _�츮������������� 10.02.04 add     
                retData._�츮������������� = d_value; 
            } else if(data.code.equals("/Y1K")){    // ������ҵ�_����Ȱ���� 09.02.03 add
                retData._������ҵ�_����Ȱ���� = d_value; 
            } else if(data.code.equals("/Y16")){    // ������ҵ�_��꺸������ 09.02.03 add
                retData._������ҵ�_��꺸������ = d_value; 
            } else if(data.code.equals("/Y15")){    // ������ҵ�_�ܱ��αٷ��� 09.02.03 add
                retData._������ҵ�_�ܱ��αٷ��� = d_value; 
            } else if(data.code.equals("/Y1G")){    // ������ҵ�-���ܱٷ�
                retData._������ҵ�_���ܱٷ� = d_value; 
            } else if(data.code.equals("/Y1E")){    // ������ҵ�-�߰��ٷμ��� ��
                _������ҵ�_�߰��ٷμ������� = d_value; 
            } else if(data.code.equals("/P06")){    // ������ҵ�-�߰��ٷμ��� ��
            	_������ҵ�_�߰��ٷμ������� = d_value;                
            } else if(data.code.equals("/Y1F")){    // ������ҵ�-��Ÿ�����
                retData._������ҵ�_��Ÿ����� = d_value; 
            } else if(data.code.equals("/Y1T")){    // �ѱ޿�
                retData._�ѱ޿� = d_value; 
            } else if(data.code.equals("/Y2D")){    // �ٷμҵ����
                retData._�ٷμҵ���� = d_value; 
            } else if(data.code.equals("/Y2E")){    // �������ٷμҵ�ݾ�
                retData._�ٷμҵ�ݾ� = d_value; 
            } else if(data.code.equals("/Y3E")){    // �⺻����- ����
                retData._�⺻����_���� = d_value; 
            } else if(data.code.equals("/Y3G")){    // �⺻����-�����
                retData._�⺻����_����� = d_value; 
            } else if(data.code.equals("/Y3P")){    // �⺻����-�ξ簡��
                retData._�⺻����_�ξ簡�� = d_value; 
            } else if(data.code.equals("/Y3S") || data.code.equals("/Y3U")){    // �߰�����-��ο�� + �߰�����-��ο��(70���̻�)
                retData._�߰�����_��ο�� = retData._�߰�����_��ο��+d_value; 
            } else if(data.code.equals("/Y3T")){    // �߰�����-�����
                retData._�߰�����_����� = d_value; 
            } else if(data.code.equals("/Y3V")){    // �߰�����-�γ���
                retData._�߰�����_�γ��� = d_value; 
            } else if(data.code.equals("/Y3X")){    // �߰�����-�ڳ������
                retData._�߰�����_�ڳ������ = d_value; 
            } else if(data.code.equals("/Y3W")){    // �߰�����_����Ծ���  09.02.03 add
                retData._�߰�����_����Ծ��� = d_value; 
            } else if(data.code.equals("/Y3Z")){    // �Ҽ��������߰�����
                retData._�Ҽ��������߰����� = d_value; 
            } else if(data.code.equals("/Y6A")){    // ���ݺ�������
                retData._���ݺ������� = d_value; 
            } else if(data.code.equals("/Y4C")){    // Ư������-�����
                retData._Ư������_����� = d_value; 
            } else if(data.code.equals("/Y4H")){    // Ư������-�Ƿ��
                retData._Ư������_�Ƿ�� = d_value; 
            } else if(data.code.equals("/Y4M")){    // Ư������-������
                retData._Ư������_������ = d_value; 
            } else if(data.code.equals("/Y5G")){    // Ư������-�����ڱ�
                retData._Ư������_�����ڱ� = d_value; 
            } else if(data.code.equals("/Y5L")){    // Ư������-�����������Աݿ����ݻ�ȯ��  09.02.03 add
                retData._Ư������_�����������Աݿ����ݻ�ȯ�� = d_value;               
            } else if(data.code.equals("/Y54")){    // Ư������-��������������Ա����ڻ�ȯ��  09.02.03 add
                retData._Ư������_��������������Ա����ڻ�ȯ�� = d_value; 
            } else if(data.code.equals("/Y5S")){    // ��αݰ������
                retData._Ư������_��α� = d_value; 
            } else if(data.code.equals("/Y5U")){    // �������(ȥ�Ρ���ʡ��̻��)
                retData._Ư������_ȥ���̻���ʺ� = d_value; 
            } else if(data.code.equals("/Y5Z")){
                retData._ǥ�ذ��� = d_value; 
            } else if(data.code.equals("/Y6B")){    // Y6B
                retData._Y6B = d_value; 
            } else if(data.code.equals("/Y6I")){    // ���ο�������ҵ����
                retData._���ο�������ҵ���� = d_value; 
            } else if(data.code.equals("/Y6Q")){    // ��������ҵ����
                retData._��������ҵ���� = d_value; 
            } else if(data.code.equals("/Y6V")){    // �����������ڵ�ҵ����
                retData._�����������ڵ�ҵ���� = d_value; 
            } else if(data.code.equals("/Y6M")){    // �ſ�ī�����
                retData._�ſ�ī����� = d_value; 
            } else if(data.code.equals("/Y6N")){    // _��Ÿ���ݺ������� 09.02.03 add
                retData._��Ÿ���ݺ������� = d_value; 
            } else if(data.code.equals("/Y6S")){    // _�������ݼҵ���� 09.02.03 add
                retData._�������ݼҵ���� = d_value; 
            } else if(data.code.equals("/Y7U")){    // �һ���ΰ����αݼҵ���� 09.02.03 add
                retData._�һ���ΰ����αݼҵ���� = d_value; 
            } else if(data.code.equals("/Y5E")){    // ���ø�������ҵ���� 09.02.03 add
                retData._���ø�������ҵ���� = d_value; 
            } else if(data.code.equals("/Y7W")){    // ����ֽ�������ҵ���� 09.02.03 add
                retData._����ֽ�������ҵ���� = d_value; 
            } else if(data.code.equals("/Y7B")){    // ���ռҵ����ǥ��
                retData._���ռҵ����ǥ�� = d_value; 
            } else if(data.code.equals("/Y7C")){    // ���⼼��
                retData._���⼼�� = d_value; 
            } else if(data.code.equals("/Y7Q")){    // ���װ���-�ҵ漼������
                retData._���װ���_�ҵ漼������ = d_value; 
            } else if(data.code.equals("/Y7V")){    // �������հ���
                retData._�������հ��� = d_value; 
            } else if(data.code.equals("/Y7R")){    // ���װ���-����Ư�����ѹ�
                retData._���װ���_����Ư�����ѹ� = d_value; 
            } else if(data.code.equals("/Y7E")){    // ���װ���-�ٷμҵ�
                retData._���װ���_�ٷμҵ� = d_value; 
            } else if(data.code.equals("/Y7G")){    // ���װ���-�������Ա�
                retData._���װ���_�������Ա� = d_value; 
            } else if(data.code.equals("/Y7I")){    // ���װ���-�ٷ����ֽ�����
                retData._���װ���_�ٷ����ֽ����� = d_value; 
            } else if(data.code.equals("/Y7M")){    // ���װ���-�ܱ�����
                retData._���װ���_�ܱ����� = d_value; 
            } else if(data.code.equals("/Y7N")){    // ��ġ��α�
                retData._���װ���_�����ġ�ڱ� = d_value;
            } else if(data.code.equals("/Y7V")){    // _�������հ���
                retData._�������հ��� = d_value;
//            } else if(data.code.equals("/Y7J")){    // ���װ���-�����������
//                retData._����������� = d_value;
            } else if(data.code.equals("/Y8I")){    // ��������(���ټ�)_������ ����
               // retData._��������_���ټ� = d_value - (d_value % 10); 
               retData._��������_���ټ� = d_value;
            } else if(data.code.equals("/Y8R")){    // ��������(�ֹμ�)_������ ����
                //retData._��������_�ֹμ� = d_value - (d_value % 10); 
            	retData._��������_�ֹμ� = d_value;
            } else if(data.code.equals("/Y8S")){    // ��������(��Ư��)_������ ����
                //retData._��������_��Ư�� = d_value - (d_value % 10); 
            	retData._��������_��Ư�� = d_value;
            } else if(data.code.equals("/Y9I")){    // �ⳳ�μ���(���ټ�)
                retData._�ⳳ�μ���_���ټ� = d_value; 
            } else if(data.code.equals("/Y9R")){    // �ⳳ�μ���(�ֹμ�)
                retData._�ⳳ�μ���_�ֹμ� = d_value; 
            } else if(data.code.equals("/Y9S")){    // �ⳳ�μ���(��Ư��)
                retData._�ⳳ�μ���_��Ư�� = d_value; 
            } else if(data.code.equals("/YAI")){    // ����¡������(���ټ�)
                retData._����¡������_���ټ� = d_value; 
            } else if(data.code.equals("/YAR")){    // ����¡������(�ֹμ�)
                retData._����¡������_�ֹμ� = d_value; 
            } else if(data.code.equals("/YAS")){    // ����¡������(��Ư��)
                retData._����¡������_��Ư�� = d_value; 
            } else if(data.code.equals("/Y42")){    // �ǰ�����
                retData._�ǰ����� = d_value; 
            } else if(data.code.equals("/Y44")){    // ��뺸�� 
                retData._��뺸�� = d_value; 
            }
        }
 
        retData._�ֽĸż����ñ�������� = _�ֽĸż����ñ������������ - _�ֽĸż����ñ������������;
        retData._������ҵ�_�߰��ٷμ��� =  _������ҵ�_�߰��ٷμ������� -_������ҵ�_�߰��ٷμ�������; 
        retData._�׹��Ǽҵ������ = retData._Y6B -  retData._���ռҵ����ǥ��; // "=/Y6B - /Y7B"  09.02.03 add
        retData._���ο��ݺ������� = retData._���ݺ������� -  retData._��Ÿ���ݺ�������; // "=/Y6A - /Y6N"  09.02.03 add
        retData._������ҵ�_��Ÿ����� = retData._������ҵ�_��Ÿ�����-(retData._������ҵ�_��꺸������ +retData._������ҵ�_�ܱ��αٷ��� +retData._������ҵ�_����Ȱ����);
//      ������ҵ� �հ�   09.02.03 add
        retData._������ҵ�_�հ� = retData._������ҵ�_���ܱٷ� + retData._������ҵ�_�߰��ٷμ��� + retData._������ҵ�_��Ÿ�����
                                           + retData._������ҵ�_����Ȱ���� + retData._������ҵ�_��꺸������ + retData._������ҵ�_�ܱ��αٷ���;
//      Ư������ �հ� 09.02.03 add
        retData._Ư������_�� = retData._Ư������_�����   + retData._Ư������_�Ƿ�� + retData._Ư������_������ 
                             //      09.02.03 delete+ retData._Ư������_�����ڱ� 
                             + retData._Ư������_��α� + retData._Ư������_ȥ���̻���ʺ�
                             + retData._Ư������_��������������Ա����ڻ�ȯ�� + retData._Ư������_�����������Աݿ����ݻ�ȯ��;
//      �����ҵ�ݾ�
        retData._�����ҵ�ݾ� = retData._�ٷμҵ�ݾ� 
                              - (retData._�⺻����_����      + retData._�⺻����_����� + retData._�⺻����_�ξ簡�� +
                                 retData._�߰�����_��ο��  + retData._�߰�����_����� + retData._�߰�����_�γ���   + retData._�߰�����_�ڳ������
                                 + retData._�߰�����_����Ծ���
                                 + retData._�Ҽ��������߰����� 
                                 // 09.02.03 delete + retData._���ݺ�������  
                                 + retData._���ο��ݺ�������  + retData._��Ÿ���ݺ�������  + retData._�������ݼҵ���� 
                                 + retData._ǥ�ذ���          + 
                                 retData._Ư������_�����    + retData._Ư������_�Ƿ�� + retData._Ư������_������   
                                // 09.02.03 delete  + retData._Ư������_�����ڱ� 
                                 + retData._Ư������_��α�    + retData._Ư������_ȥ���̻���ʺ�
                                 + retData._Ư������_��������������Ա����ڻ�ȯ�� + retData._Ư������_�����������Աݿ����ݻ�ȯ��);
//      ���װ��� �հ�
        retData._���װ���_���鼼�װ� = retData._���װ���_�ҵ漼������ + retData._���װ���_����Ư�����ѹ�;
//      ���װ��� �հ�
        retData._���װ���_���װ����� = retData._���װ���_�ٷμҵ� + retData._���װ���_�������Ա� + retData._���װ���_�ٷ����ֽ����� 
                                     + retData._���װ���_�ܱ����� + retData._���װ���_�����ġ�ڱ�;
//      �������� �հ� 
        retData._��������_�հ� = retData._��������_���ټ� + retData._��������_�ֹμ� + retData._��������_��Ư��;
//      _�����ٹ��� �հ�
        retData._����_�հ� = retData._����_�ҵ漼 + retData._����_�ֹμ�;
//      �ⳳ�μ��� �հ�
        retData._�ⳳ�μ���_�հ� = retData._�ⳳ�μ���_���ټ� + retData._�ⳳ�μ���_�ֹμ� + retData._�ⳳ�μ���_��Ư��;
//      ����¡������ �հ�
        retData._����¡������_�հ� =retData. _����¡������_���ټ� + retData._����¡������_�ֹμ� + retData._����¡������_��Ư��;

        return retData ;
    }
}