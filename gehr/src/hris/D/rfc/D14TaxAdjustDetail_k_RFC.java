package hris.D.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 *  D14TaxAdjustDetail_k_RFC.java
 *  (�ؿܱٹ���)���� �������� ��������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �� ��ȣ
 * @version 1.0, 2003/03/03
 */
public class D14TaxAdjustDetail_k_RFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_READ_YEA_RESULT3" ;

    /**
     * (�ؿܱٹ���)���� �������� ��������� �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param empNo java.lang.String �����ȣ
     * @param GJAHR java.lang.String ȸ��⵵
     * @exception com.sns.jdf.GeneralException
     */
    public Object detail( String empNo, String GJAHR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, GJAHR);
            excute(mConnection, function);
            Vector ret = getOutput( function );
            D14TaxAdjustData_k data = (D14TaxAdjustData_k)metchData(ret);
            // �������곻����ȸ�Ⱓ�̶� �����Ͱ� ������� flag�� �ܴ�.
            if(ret.size()==0){
                data.isUsableData = "NO";
            }
 
            return data;
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
     * @param GJAHR java.lang.String ȸ��⵵
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String GJAHR ) throws GeneralException {
        String fieldName1 = "PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "GJAHR";
        setField( function, fieldName2, GJAHR );
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
        String tableName = "RTAB";      // RFC Export ������� ����
        String codeField = "LGART";      // RFC Export table�� field ������� �� CodeEntity�� "code" �� �� Field Name 
        String valueField = "BETRG";     // RFC Export table�� field ������� �� CodeEntity�� "value" �� �� Field Name 
        return getCodeVector( function, tableName, codeField, valueField );
    }


    private Object metchData(Vector ret) throws GeneralException {

        D14TaxAdjustData_k retData = new D14TaxAdjustData_k();
        Logger.debug.println(this, ret.toString());

        double Data_Y6N =0; //�ӽð��
        double Data_P16 =0; //�ӽð��
        double Data_Y6S =0; //�ӽð��
        double Data_P21 =0; //�ӽð��
        for( int i = 0 ; i < ret.size() ; i++ ){
            CodeEntity data = (CodeEntity)ret.get(i);
            double d_value = 0;
            
            if(data.value.equals("")) {
              d_value = 0;
            } else { 
              d_value = Double.parseDouble(data.value) * 100.0;
            } // 100�� ���ؼ� ��ȯ���ش�. 2002.05.03.

            if(data.code.equals("/Y1A")){     // �޿��Ѿ�
                    retData._�޿��Ѿ� = d_value; 
            } else if(data.code.equals("/Y1B")){    // ���Ѿ�
                    retData._���Ѿ� = d_value; 
            } else if(data.code.equals("/Y1C")){    // ������
                    retData._������ = d_value; 
            } else if(data.code.equals("/Y1T")){    // �ѱ޿�
                    retData._�ѱ޿� = d_value; 
            } else if(data.code.equals("/Y1G")){    // ������ҵ�-���ܱٷ�
                    retData._������ҵ�_���ܱٷ� = d_value; 
            } else if(data.code.equals("/Y1E")){    // ������ҵ�-�߰��ٷμ��� ��
                    retData._������ҵ�_�߰��ٷμ��� = d_value; 
            } else if(data.code.equals("/Y1F")){    // ������ҵ�-��Ÿ�����
                    retData._������ҵ�_��Ÿ����� = d_value; 
            } else if(data.code.equals("/Y2D")){    // �ٷμҵ����
                    retData._�ٷμҵ���� = d_value; 
            } else if(data.code.equals("/Y2E")){    // �������ٷμҵ�ݾ�
                    retData._�������ٷμҵ�ݾ� = d_value; 
            } else if(data.code.equals("/Y3E")){    // �⺻����- ����
                    retData._�⺻����_���� = d_value; 
            } else if(data.code.equals("/Y3G")){    // �⺻����-�����
                    retData._�⺻����_����� = d_value; 
            } else if(data.code.equals("/Y3P")){    // �⺻����-�ξ簡��
                    retData._�⺻����_�ξ簡�� = d_value; 
            } else if(data.code.equals("/Y3S")){    // �߰�����-��ο��
                    retData._�߰�����_��ο�� = d_value; 
            } else if(data.code.equals("/Y3U")){    // �߰�����-��ο��(70���̻�)
                    retData._�߰�����_��ο��70 = d_value; 
            } else if(data.code.equals("/Y3T")){    // �߰�����-�����
                    retData._�߰�����_����� = d_value; 
            } else if(data.code.equals("/Y3V")){    // �߰�����-�γ���
                    retData._�߰�����_�γ��� = d_value; 
            } else if(data.code.equals("/Y3W")){    // �߰�����-����Ծ��߰����� 2008.12
                retData._�߰�����_����Ծ� = d_value; 
            } else if(data.code.equals("/Y3X")){    // �߰�����-�ڳ������
                    retData._�߰�����_�ڳ������ = d_value; 
            } else if(data.code.equals("/Y3Z")){    // �Ҽ��������߰�����
                    retData._�Ҽ��������߰����� = d_value; 
            } else if(data.code.equals("/Y4C")){    // Ư������-�����
                    retData._Ư������_����� = d_value; 
            } else if(data.code.equals("/Y4H")){    // Ư������-�Ƿ��
                    retData._Ư������_�Ƿ�� = d_value; 
            } else if(data.code.equals("/Y4M")){    // Ư������-������
                    retData._Ư������_������ = d_value; 
            } else if(data.code.equals("/Y54")){    // Ư������-�����ڱ����ڻ�ȯ�� 2008.12
                retData._Ư������_�����ڱ����ڻ�ȯ�� = d_value; 
            } else if(data.code.equals("/Y5E")){    // Ư������-���ø�������ҵ���� 2008.12
                retData._Ư������_���ø�������ҵ���� = d_value; 
            } else if(data.code.equals("/Y5G")){    // Ư������-�����ڱ�
                    retData._Ư������_�����ڱ� = d_value; 
            } else if(data.code.equals("/Y5L")){    // Ư������-�����������Աݿ����ݻ�ȯ�� 2008.12
                retData._Ư������_�����������Աݿ����ݻ�ȯ�� = d_value; 
            } else if(data.code.equals("/Y5S")){    // ��αݰ������
                    retData._Ư������_��α� = d_value; 
            } else if(data.code.equals("/Y5U")){    // �������(ȥ�Ρ���ʡ��̻��)
                    retData._Ư������_������� = d_value; 
            } else if(data.code.equals("/Y5Z")){    // Ư��������(�Ǵ� ǥ�ذ���)
                    retData._Ư�������� = d_value; 
            } else if(data.code.equals("/Y6A")){    // ���ݺ�������
                    retData._���ݺ������� = d_value; 
            } else if(data.code.equals("/Y6N")){    // Y6N
            	Data_Y6N += d_value; 
            } else if(data.code.equals("/P16")){    // P16
            	Data_P16 += d_value; 
            } else if(data.code.equals("/Y6S")){    // Y6S
            	Data_Y6S += d_value; 
            } else if(data.code.equals("/P21")){    // P21
            	Data_P21 += d_value;       
            } else if(data.code.equals("/Y68")){    // Ư������_������    "/Y68" 2011.01 
                retData._Ư������_������ = d_value; 
            } else if(data.code.equals("/Y6I")){    // ���ο�������ҵ����
                    retData._���ο�������ҵ���� = d_value; 
            } else if(data.code.equals("/Y6Q")){    // ��������ҵ����
                    retData._��������ҵ���� = d_value; 
            } else if(data.code.equals("/Y6V")){    // �����������ڵ�ҵ����
                    retData._�����������ڵ�ҵ���� = d_value; 
            } else if(data.code.equals("/Y6M")){    // �ſ�ī�����
                    retData._�ſ�ī����� = d_value; 
            } else if(data.code.equals("/Y7B")){    // ���ռҵ����ǥ��
                    retData._���ռҵ����ǥ�� = d_value; 
            } else if(data.code.equals("/Y7C")){    // ���⼼��
                    retData._���⼼�� = d_value; 
            } else if(data.code.equals("/Y7E")){    // ���װ���-�ٷμҵ�
                    retData._���װ���_�ٷμҵ� = d_value; 
            } else if(data.code.equals("/Y7G")){    // ���װ���-�������Ա�
                    retData._���װ���_�������Ա� = d_value; 
            } else if(data.code.equals("/Y7I")){    // ���װ���-�ٷ����ֽ�����
                    retData._���װ���_�ٷ����ֽ����� = d_value; 
            } else if(data.code.equals("/Y7J")){    // ���װ���-�����������
                    retData._����������� = d_value;
            } else if(data.code.equals("/Y7M")){    // ���װ���-�ܱ�����
                    retData._���װ���_�ܱ����� = d_value; 
            } else if(data.code.equals("/Y7N")){    // ��ġ��α�
                    retData._��ġ��α� = d_value;
            } else if(data.code.equals("/Y7Q")){    // ���װ���-�ҵ漼������
                    retData._���װ���_�ҵ漼������ = d_value; 
            } else if(data.code.equals("/Y7R")){    // ���װ���-����Ư�����ѹ�
                    retData._���װ���_����Ư�����ѹ� = d_value; 
            } else if(data.code.equals("/Y7W")){    // ���װ���-����ֽ��ݵ�ҵ���� 2008.12
                retData._���װ���_����ֽ�������ҵ���� = d_value; 
            } else if(data.code.equals("/Y8I")){    // ��������(���ټ�)_������ ����
                    retData._��������_���ټ� = d_value;// - (d_value % 10); 
            } else if(data.code.equals("/Y8R")){    // ��������(�ֹμ�)_������ ����
                    retData._��������_�ֹμ� = d_value;// - (d_value % 10); 
            } else if(data.code.equals("/Y8S")){    // ��������(��Ư��)_������ ����
                    retData._��������_��Ư�� = d_value;// - (d_value % 10); 
            } else if(data.code.equals("/Y9I")){    // �ⳳ�μ���(���ټ�)
                    retData._�ⳳ�μ���_���ټ� = d_value; 
            } else if(data.code.equals("/Y9R")){    // �ⳳ�μ���(�ֹμ�)
                    retData._�ⳳ�μ���_�ֹμ� = d_value; 
            } else if(data.code.equals("/Y9S")){    // �ⳳ�μ���(��Ư��)
                    retData._�ⳳ�μ���_��Ư�� = d_value; 
            } else if(data.code.equals("1501")){    // ����¡������(���ټ�)
                    retData._����¡������_���ټ� = d_value; 
            } else if(data.code.equals("1502")){    // ����¡������(�ֹμ�)
                    retData._����¡������_�ֹμ� = d_value; 
            } else if(data.code.equals("/YAS")){    // ����¡������(��Ư��)
                    retData._����¡������_��Ư�� = d_value; 
//          2003.01.14. - ���ٹ��� ������ �߰��ȴ�. 
            } else if(data.code.equals("/P01")){    // ���ٹ��� ������ �޿��׸� ������ (����)
                    retData._���ٹ���_�޿��Ѿ� = d_value; 
            } else if(data.code.equals("/P02")){    // ���ٹ��� ������ �޿��׸� ������ (����)
                    retData._���ٹ���_���Ѿ� = d_value; 
            } else if(data.code.equals("/P13")){    // ���ٹ��� ������ ������ �׸����� (����) 
                    retData._���ٹ���_������ = d_value;
            } else if(data.code.equals("/P03")){    // �ⳳ�μ��׿� �ջ�
                    retData._���ٹ���_���μҵ漼 = d_value;
            } else if(data.code.equals("/P04")){    // �ⳳ�μ��׿� �ջ�
                    retData._���ٹ���_�����ֹμ� = d_value;
            } else if(data.code.equals("/P05")){    // ������ҵ濡�ջ�
                    retData._���ٹ���_������ؿܼҵ� = d_value;
            } else if(data.code.equals("/P06")){    // ������ҵ濡�ջ�
                    retData._���ٹ���_������ʰ��ٹ� = d_value;
            } else if(data.code.equals("/P07")){    // ������ҵ濡�ջ�
                    retData._���ٹ���_��Ÿ�������� = d_value;
            } else if(data.code.equals("/P14")){    // �ⳳ�μ��׿� �ջ�
                    retData._���ٹ���_����Ư���� = d_value;
            }
        }
        // ���ٹ��� �޿�,�������� �ٽ� ���Ѵ�.
        retData._�޿��Ѿ� -= retData._���ٹ���_�޿��Ѿ�;
        retData._���Ѿ� -= retData._���ٹ���_���Ѿ�;
        retData._������ -= retData._���ٹ���_������;
        
        // ������ҵ� �հ� - �������� _������ҵ�_���ܱٷθ� �����Ѵ�. (2003.03.11)
        double hap7  = retData._������ҵ�_�߰��ٷμ���;
               hap7 += retData._������ҵ�_��Ÿ�����  ;
               hap7 += retData._���ٹ���_������ؿܼҵ�;
               hap7 += retData._���ٹ���_������ʰ��ٹ�;
               hap7 += retData._���ٹ���_��Ÿ��������;
        
        retData._������ҵ� = hap7;
        
        // Ư��������(�Ǵ� ǥ�ذ���) �� ��� �ʿ�
        double hap  = retData._Ư������_�����  ;
               hap += retData._Ư������_�Ƿ��  ;
               hap += retData._Ư������_������  ;
               hap += retData._Ư������_�����ڱ�;
               hap += retData._Ư������_��α�  ;
			   hap += retData._Ư������_�������  ;
			   hap += retData._Ư������_������; //2011.01

        retData._Ư�������� = ( (retData._Ư�������� > hap) ? retData._Ư�������� : hap );
        
        // �����ҵ�ݾ� ���
        double hap2  = retData._�⺻����_����       ;
               hap2 += retData._�⺻����_�����     ;
               hap2 += retData._�⺻����_�ξ簡��   ;
               hap2 += retData._�߰�����_��ο��   ;
			   hap2 += retData._�߰�����_��ο��70	;
               hap2 += retData._�߰�����_�����     ;
               hap2 += retData._�߰�����_�γ���     ;
               hap2 += retData._�߰�����_�ڳ������ ;
               hap2 += retData._�Ҽ��������߰�����  ;
               hap2 += retData._Ư��������          ;
               hap2 += retData._���ݺ�������      ;

        retData._�����ҵ�ݾ� = retData._�������ٷμҵ�ݾ� - hap2 ;
        
        // Ư������_��α� ��� 
//        retData._Ư������_��α� = retData._Ư������_��α�1 + retData._Ư������_��α�2 ;
  
        // ���װ����հ� ���
        double hap3  = retData._���װ���_�ٷμҵ�       ;
               hap3 += retData._���װ���_�������Ա�     ;
               hap3 += retData._���װ���_�ٷ����ֽ����� ;
               hap3 += retData._�����������            ;
			   hap3 += retData._��ġ��α�					;
               hap3 += retData._���װ���_�ܱ�����       ;

        retData._���װ����հ� = hap3 ;

        // ���������հ� ���       
        double hap4  = retData._��������_���ټ� ;
               hap4 += retData._��������_�ֹμ� ;
               hap4 += retData._��������_��Ư�� ;

        retData._���������հ� = hap4 ;

        // �ⳳ�μ����հ� ���
//        retData._�ⳳ�μ���_���ټ� += retData._���ٹ���_���μҵ漼;
//        retData._�ⳳ�μ���_�ֹμ� += retData._���ٹ���_�����ֹμ�;
//        retData._�ⳳ�μ���_��Ư�� += retData._���ٹ���_����Ư����;
        double hap5  = retData._�ⳳ�μ���_���ټ� ;
               hap5 += retData._�ⳳ�μ���_�ֹμ� ;
               hap5 += retData._�ⳳ�μ���_��Ư�� ;

        retData._�ⳳ�μ����հ� = hap5 ;

        // ����¡�������հ� ���   
        double hap6  = retData._����¡������_���ټ� ;
               hap6 += retData._����¡������_�ֹμ� ;
               hap6 += retData._����¡������_��Ư�� ;

        retData._����¡�������հ� = hap6 ;

        retData._���ݺ�������_���� = retData._���ݺ������� - Data_Y6N; //   "/Y6A - /Y6N" 20111.01
        retData._���ݺ�������_��Ÿ = Data_Y6N + Data_P16;                   //   "/Y6N + /P16" 20111.01
        retData._���ݺ�������_���� = Data_Y6S + Data_P21;                   //   "/Y6S + /P21" 20111.01

Logger.debug.println(this, retData.toString());
        return retData ;
    }
}