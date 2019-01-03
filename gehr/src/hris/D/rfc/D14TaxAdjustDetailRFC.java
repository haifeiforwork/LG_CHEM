package hris.D.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;
import hris.D.D05Mpay.D05MpayDetailData5;

/**
 *  D14TaxAdjustDetailRFC.java
 *  �������� ��������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/01/28  2013/02/06  /Y79 :Ư������_�����������ڻ�ȯ�� �߰� Ư������ > �����ڱ�(�������������ݻ�ȯ�ס������ס������������ڻ�ȯ��) �� �ݾ׿� �߰�
 * @version 2.0 2014/01/17  C20140106_63914 ABART : ���� *, ''  �ؿ�  S �ؿܱٹ��Ⱓ(1~6��), T �ؿܱٹ��Ⱓ(7~12��) L �����ٹ��Ⱓ  �׸� �߰��Ǿ� ��������
 * @version 3.0 2015/05/18 [CSR ID:2778743] �������� ������ȸ ȭ�� ����
 * @version 4.0 2016/02/03 [CSR ID:2974323] �������� ������ȸ ���¿�û 20160203 �߰�

 */
public class D14TaxAdjustDetailRFC extends SAPWrap {

    private  static String functionName = "ZSOLYR_RFC_READ_YEA_RESULT" ;

    /**
     * �������� ��������� �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param empNo java.lang.String �����ȣ
     * @param GJAHR java.lang.String ȸ��⵵
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String empNo, String GJAHR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, GJAHR);
            excute(mConnection, function);

            //C20140106_63914 ABART : ���� *, ''  �ؿ�  S �ؿܱٹ��Ⱓ(1~6��), T �ؿܱٹ��Ⱓ(7~12��) L �����ٹ��Ⱓ

            Vector ret = getOutput( function  );
            //Logger.sap.println(this, "detail ret : "+ret.toString());
            D14TaxAdjustData data = (D14TaxAdjustData)metchData(ret,"*" ); //���� *, ''
            D14TaxAdjustData data1 = (D14TaxAdjustData)metchData(ret,"S" ); //S �ؿܱٹ��Ⱓ(1~6��)
            D14TaxAdjustData data2 = (D14TaxAdjustData)metchData(ret,"T" ); // T �ؿܱٹ��Ⱓ(7~12��)
            D14TaxAdjustData data3 = (D14TaxAdjustData)metchData(ret,"L" ); // L �����ٹ��Ⱓ


            // �������곻����ȸ�Ⱓ�̶� �����Ͱ� ������� flag�� �ܴ�.
            if(ret.size()==0){
                data.isUsableData = "NO";
            }
            Vector retvt = new Vector();
            retvt.addElement(data);
            retvt.addElement(data1);
            retvt.addElement(data2);
            retvt.addElement(data3);

           // Logger.sap.println(this, "detail retvt : "+retvt.toString());

            return retvt;
            //return data;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public String GetMessage( String empNo, String GJAHR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, GJAHR);
            excute(mConnection, function);
            String E_MESSAGE = getOutput1( function );

            return E_MESSAGE;
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
    private Vector getOutput(JCO.Function function ) throws GeneralException {
        String tableName = "RTAB";      // RFC Export ������� ����
        String codeField = "LGART";      // �ӱ� �����ӱ� ����
        String valueField = "BETRG";     // HR �޿�����: �ݾ�
        String gubnField = "ABART";     // �޿� ��� ��Ģ�� ���� ��� ���� �׷� �׷���
        String subCodeField = "CNTR1"; //�ǰ������, ��뺸��� ������ ����(/Y4C-01,/Y4C-02) //@2014 �������� �߰�
        String subCodeField2 = "V0ZNR"; //��α� ��� ���ǿ� �ʿ� ( �ش� ���� 01�� �ƴ� ���� sum) //@2014 �������� �߰�
        String reTax2014 = "BTZNR";//2014�������� ������


        Vector retvt = new Vector();
        try{
            JCO.Table table = function.getTableParameterList().getTable(tableName);

            for (int i = 0; i < table.getNumRows(); i++) {
                table.setRow(i);

                D14TaxAdjustCodeData ret = new D14TaxAdjustCodeData();

                ret.code = table.getString(codeField);
                ret.value = table.getString(valueField);
                ret.gubn = table.getString(gubnField);
                ret.subCode = table.getString(subCodeField); //@2014 �������� �߰�
                ret.subCode2 = table.getString(subCodeField2); //@2014 �������� �߰�
                ret.reTax2014 = table.getString(reTax2014);//2014�������� ������


                //Logger.debug.println(this, ret.toString());
                DataUtil.fixNullAndTrim( ret );
                retvt.addElement(ret);
            }


            //Logger.debug.println(this, "************getCodeVector()  ...�� ********* tableName : "+tableName );
        } catch ( Exception ex ){
            Logger.debug.println(this, "getCodeVector( JCO.Function function, String tableName, String codeField, String valueField )���� ���ܹ߻� " );
            throw new GeneralException(ex);
        }

        return retvt;


       // return getTable(entityName, function, tableName);
        //return getCodeVector( function, tableName, codeField, valueField );
    }

    private Object metchData(Vector ret,String gubn) throws GeneralException {

        D14TaxAdjustData retData = new D14TaxAdjustData();

        double Data_Y6N =0; //�ӽð��
        double Data_P16 =0; //�ӽð��
        //double Data_Y6S =0; //�ӽð��
        //double Data_P21 =0; //�ӽð��
        retData.Count =0;
        int notChangePerson = 0;

        //[CSR ID:2778743] ������ �ƴ� �ο� ���п�
        for( int i = 0 ; i < ret.size() ; i++ ){

        	D14TaxAdjustCodeData data = (D14TaxAdjustCodeData)ret.get(i);
        	if("77".equals(data.reTax2014)){
        		notChangePerson += 1;
        	}
        }
        retData.notCngPerson = notChangePerson;


        String tmpABART =null;//�޿� ��� ��Ģ�� ���� ��� ���� �׷� �׷���
        for( int i = 0 ; i < ret.size() ; i++ ){

        	D14TaxAdjustCodeData data = (D14TaxAdjustCodeData)ret.get(i);
        	if (gubn.equals("*")) { //����
	        	if (data.gubn.equals("*")|| data.gubn.equals("")|| data.gubn==null){
	        		//tmpABART=data.gubn;
	        		tmpABART="*";
	        	}else{
	        		tmpABART="NA";
	        	}
        	}else{
        		tmpABART = data.gubn;
	        }
            //Logger.debug.println(this,"1 metchData: gubn "+ gubn+"tmpABART:"+tmpABART );
        	if (gubn.equals(tmpABART)) {

                retData.ABART =data.gubn;
        		double d_value = 0;

		            if(data.value.equals("")) {
		              d_value = 0;
		            } else {
		              d_value = Double.parseDouble(data.value) * 100.0;
		            } // 100�� ���ؼ� ��ȯ���ش�. 2002.05.03.

	        		retData.Count = retData.Count+1; // C20140106_63914

	         if(!"77".equals(data.reTax2014)){
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
		            } else if(data.code.equals("/Y3W")){    // �߰�����-����Ծ��߰����� 2008.12  20150126 ���� [CSR ID:2778743]�߰�
		                retData._�߰�����_����Ծ� = d_value;
		            } else if(data.code.equals("/Y3X")){    // �߰�����-�ڳ������						 20150126 ���� [CSR ID:2778743]�߰�
		                    retData._�߰�����_�ڳ������ = d_value;
		            } else if(data.code.equals("/Y3Z")){    // �Ҽ��������߰�����	 => ���װ���_�ڳ� 20150126 ����
	                    retData._���װ���_�ڳ� = d_value;
		            } else if(data.code.equals("/Y4C")&&data.subCode.equals("01")){    // Ư������-�����
		                    retData._Ư������_�ǰ������ = d_value;
		            } else if(data.code.equals("/Y4C")&&data.subCode.equals("02")){    // Ư������-�����
	                    retData._Ư������_��뺸��� = d_value;
		            //} else if(data.code.equals("/Y4H")){    // Ư������-�Ƿ��				20150126 ����
		            //        retData._Ư������_�Ƿ�� = d_value;
		            //} else if(data.code.equals("/Y4M")){    // Ư������-������				20150126 ����
		            //        retData._Ư������_������ = d_value;
		            } else if(data.code.equals("/Y54")){    // Ư������-�����ڱ����ڻ�ȯ�� 2008.12
		                retData._Ư������_�����ڱ����ڻ�ȯ�� = d_value;
		            } else if(data.code.equals("/Y5E")){    // Ư������-���ø�������ҵ���� 2008.12
		                retData._Ư������_���ø�������ҵ���� = d_value;
		            //} else if(data.code.equals("/Y5G")){    // Ư������-�����ڱ�
		            //    retData._Ư������_�����ڱ� = d_value;
		            } else if(data.code.equals("/Y5L")){    // Ư������-�����������Աݿ����ݻ�ȯ�� 2008.12
		                retData._Ư������_�����������Աݿ����ݻ�ȯ�� = d_value;
		            }else if(data.code.equals("/Y5S")&&!data.subCode2.equals("01")){    // ��αݰ������				20150126 �ڵ� ����  Y5S  && subcode2�� 01�� �ƴ� ���� sum
		                    retData._Ư������_��α� += d_value;
		            //} else if(data.code.equals("/Y5U")){    // �������(ȥ�Ρ���ʡ��̻��) 20150126 ����
		            //        retData._Ư������_������� = d_value;
		            } else if(data.code.equals("/Y5Z")){    // Ư��������(�Ǵ� ǥ�ذ���)
	                    retData._���װ���_ǥ�ؼ��װ��� = d_value;
		            } else if(data.code.equals("/Y6A")){    // ���ݺ�������
		                    retData._���ݺ������� = d_value;
		            } else if(data.code.equals("/Y6N")){    // Y6N 20111.01
		            	Data_Y6N = d_value;
		            	retData._���ݺ�������_��Ÿ = d_value;
		            //} else if(data.code.equals("/P16")){    // P16       20150126 ����
		            //	Data_P16 = d_value;
		            //} else if(data.code.equals("/Y6S")){    // Y6S      20150126 ����
		            	//Data_Y6S = d_value;
		            //    retData._���ݺ�������_���� = d_value;
		            //} else if(data.code.equals("/P21")){    // P21
		            	//Data_P21 = d_value;
		            //} else if(data.code.equals("/Y6B")){    // _�����ҵ�ݾ�    "/Y6B" 2011.01   20150126����
		            //    retData._�����ҵ�ݾ� = d_value;
		            //} else if(data.code.equals("/Y6D")){     // �츮�������� �ҵ����   "/Y6D" 20111.01   20150126����
		            //    retData._�츮�������ռҵ���� = d_value;
		            } else if(data.code.equals("/Y88")){    // Ư������_������    "/Y88" 2011.01
		                retData._���װ���_������ = d_value;
		            } else if(data.code.equals("/Y79")){    // Ư������_������    "/Y79" 2013.01
		                retData._Ư������_�����������Ա����ڰ����� = d_value;
		            } else if(data.code.equals("/Y6I")){    // ���ο�������ҵ����
		                retData._���ο�������ҵ���� = d_value;
		            //} else if(data.code.equals("/Y6Q")){    // ��������ҵ����						20150126����
		            //        retData._��������ҵ���� = d_value;
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
		            //} else if(data.code.equals("/Y7I")){    // ���װ���-�ٷ����ֽ�����   20150126 ����
		            //        retData._���װ���_�ٷ����ֽ����� = d_value;
		            //} else if(data.code.equals("/Y7J")){    // ���װ���-�����������	 20150126 ����
		            //        retData._����������� = d_value;
		            //} else if(data.code.equals("/Y7M")){    // ���װ���-�ܱ�����			 20150126 ����
		            //        retData._���װ���_�ܱ����� = d_value;
		            } else if(data.code.equals("/Y7N")||(data.code.equals("/Y87")&&data.subCode.equals("20"))){    // ��ġ��α�
		                    retData._���װ���_��ġ��α� += d_value;
		            //} else if(data.code.equals("/Y7Q")){    // ���װ���-�ҵ漼������			20150126 ����
		            //        retData._���װ���_�ҵ漼������ = d_value;
		            //} else if(data.code.equals("/Y7R")){    // ���װ���-����Ư�����ѹ�			20150126 ����
		            //        retData._���װ���_����Ư�����ѹ� = d_value;
		            //} else if(data.code.equals("/Y7W")){    // ���װ���-����ֽ��ݵ�ҵ���� 2008.12		20150126 ����
		            //    retData._���װ���_����ֽ�������ҵ���� = d_value;
		            } else if(data.code.equals("/Y7U")){    // �ұ��.�һ���� �����α� �ҵ����   "/Y7U" 20111.0		20150126 ����  [CSR ID:2974323] �������� ������ȸ ���¿�û 20160203 �߰�
		                retData._�ұ����ҵ���� = d_value;
		            //} else if(data.code.equals("/Y7V")){    //  �������հ���  C20120214_50550   20120214			20150126 ����
		            //    retData._�������հ��� = d_value;

		            } else if(data.code.equals("/Y8I")){    // ��������(���ټ�)_������ ����
		                   // retData._��������_���ټ� = d_value - (d_value % 10);
		            	 retData._��������_���ټ� = d_value ;

		            } else if(data.code.equals("/Y8R")){    // ��������(�ֹμ�)_������ ����
		                   // retData._��������_�ֹμ� = d_value - (d_value % 10);
		                    retData._��������_�ֹμ� = d_value;

		            } else if(data.code.equals("/Y8S")){    // ��������(��Ư��)_������ ����
		                    retData._��������_��Ư�� = d_value - (d_value % 10);
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
		            } else if(data.code.equals("/YSP")){    // CSR ID:C20140106_63914 �Ѻθ���
		                    retData._�߰�����_�Ѻθ��� = d_value;
		            } else if(data.code.equals("/YAA")){    // CSR ID:C20140106_63914 Ư������ �����ѵ� �ʰ���
		                    retData._Ư������_�����ѵ�_�ʰ��� = d_value;

		                    //@2014 �������� ��ȸ �߰�
		            } else if(data.code.equals("/YC4")){    // ���װ���
	                    retData._�׹���_������������������� = d_value;
		            } else if(data.code.equals("/Y82")){    // ���װ���
		                    retData._���װ���_�������ݼҵ���� = d_value;
		            } else if(data.code.equals("/Y83")){    // ���װ���
		                    retData._���װ���_��������ҵ���� = d_value;
		            } else if(data.code.equals("/Y84")){    // _���װ���_���强�����
		                    retData._���װ���_���强����� = d_value;
		            } else if(data.code.equals("/Y85")){    // ���װ���
		                    retData._���װ���_�Ƿ�� = d_value;
		            } else if(data.code.equals("/Y86")){    // ���װ���
		                    retData._���װ���_������ = d_value;
		            } else if(data.code.equals("/Y87")&&!data.subCode.equals("20")){    // ���װ���
		                    retData._���װ���_��α� += d_value;
		            }
		     }else if("77".equals(data.reTax2014)){
		            if(data.code.equals("/Y3Z")){    // _���װ���_�ڳ�_�� + reTax2014 = 77          [CSR ID:2778743]
	                    retData._���װ���_�ڳ�_�� = d_value;
		            } else if(data.code.equals("/Y5Z")){    // Ư��������(�Ǵ� ǥ�ذ���) _���װ���_ǥ�ؼ��װ���_�� + reTax2014 = 77          [CSR ID:2778743]
	                    retData._���װ���_ǥ�ؼ��װ���_�� = d_value;
		            } else if(data.code.equals("/Y6M")){    // �ſ�ī�����_�� + reTax2014 = 77          [CSR ID:2778743]
                        retData._�ſ�ī�����_�� = d_value;
		            } else if(data.code.equals("/Y7B")){    // ���ռҵ����ǥ��_�� + reTax2014 = 77          [CSR ID:2778743]
                        retData._���ռҵ����ǥ��_�� = d_value;
		            } else if(data.code.equals("/Y7C")){    // ���⼼��_�� + reTax2014 = 77          [CSR ID:2778743]
                        retData._���⼼��_�� = d_value;
		            } else if(data.code.equals("/Y7E")){    // ���װ���-�ٷμҵ�_�� + reTax2014 = 77          [CSR ID:2778743]
	                    retData._���װ���_�ٷμҵ�_�� = d_value;
		            } else if(data.code.equals("/Y8I")){    // ��������(���ټ�)_������ ����     _��������_���ټ�_�� + reTax2014 = 77          [CSR ID:2778743]
		                   // retData._��������_���ټ� = d_value - (d_value % 10);
		            	 retData._��������_���ټ�_�� = d_value ;
		            } else if(data.code.equals("/Y8R")){    // ��������(�ֹμ�)_������ ����  _��������_�ֹμ�_�� + reTax2014 = 77          [CSR ID:2778743]
		                   // retData._��������_�ֹμ� = d_value - (d_value % 10);
		                    retData._��������_�ֹμ�_�� = d_value;
		            } else if(data.code.equals("/Y8S")){    // ��������(��Ư��)_������ ����   _��������_��Ư��_�� + reTax2014 = 77          [CSR ID:2778743]
	                    retData._��������_��Ư��_�� = d_value - (d_value % 10);
		            } else if(data.code.equals("/YAI")){    // ����¡������(���ټ�)   _�� + reTax2014 = 77          [CSR ID:2778743]
	                    retData._����¡������_���ټ�_�� = d_value;
		            } else if(data.code.equals("/YAR")){    // ����¡������(�ֹμ�)   _�� + reTax2014 = 77          [CSR ID:2778743]
	                    retData._����¡������_�ֹμ�_�� = d_value;
		            } else if(data.code.equals("/YAS")){    // ����¡������(��Ư��)   _�� + reTax2014 = 77          [CSR ID:2778743]
	                    retData._����¡������_��Ư��_�� = d_value;
		            } else if(data.code.equals("/Y83")){    // _���װ���_��������ҵ����_�� + reTax2014 = 77          [CSR ID:2778743]
	                    retData._���װ���_��������ҵ����_�� = d_value;
		            } else if(data.code.equals("/Y84")){    // _���װ���_���强�����_�� + reTax2014 = 77          [CSR ID:2778743]
	                    retData._���װ���_���强�����_�� = d_value;
		            }
		     }//�����꿡 ���� �� �� ����

		        }
        }


        // ���ٹ��� �޿�,�������� �ٽ� ���Ѵ�.
        retData._�޿��Ѿ� -= retData._���ٹ���_�޿��Ѿ�;
        retData._���Ѿ� -= retData._���ٹ���_���Ѿ�;
        retData._������ -= retData._���ٹ���_������;


        if (gubn.equals("S")||gubn.equals("T")||gubn.equals("L")) { //2013    �ؿ��ΰ�츸 S,T,L
	        //����¡�����׼ҵ漼 /Y8I - /Y9I
	        retData._����¡������_���ټ� = retData._��������_���ټ� - retData._�ⳳ�μ���_���ټ�;
	        //����¡�������ֹμ� /Y8R - /Y9R
	        retData._����¡������_�ֹμ� = retData._��������_�ֹμ�- retData._�ⳳ�μ���_�ֹμ�;
	        //����¡�����׳�Ư�� /Y8S - /Y9S
	        retData._����¡������_��Ư�� = retData._��������_��Ư�� - retData._�ⳳ�μ���_��Ư��;

	        // [CSR ID:2778743] _�� �߰�
	        //����¡�����׼ҵ漼 /Y8I - /Y9I
	        retData._����¡������_���ټ�_�� = retData._��������_���ټ�_�� - retData._�ⳳ�μ���_���ټ�;
	        //����¡�������ֹμ� /Y8R - /Y9R
	        retData._����¡������_�ֹμ�_�� = retData._��������_�ֹμ�_��- retData._�ⳳ�μ���_�ֹμ�;
	        //����¡�����׳�Ư�� /Y8S - /Y9S
	        retData._����¡������_��Ư��_�� = retData._��������_��Ư��_�� - retData._�ⳳ�μ���_��Ư��;
        }

        //20150126 ���������� ��ȸ
        //1) ��� ���  => /Y3S+/Y3U
        retData._�߰�����_��ο�� += retData._�߰�����_��ο��70;

        //2) �����ڱ�(�����������Կ����ݻ�ȯ��, �������Ա����ڻ�ȯ��) => /Y5L+/Y54+/Y64


 /*20150126
  *       // ������ҵ� �հ�
        double hap7  = retData._������ҵ�_���ܱٷ�    ;
               hap7 += retData._������ҵ�_�߰��ٷμ���;
               hap7 += retData._������ҵ�_��Ÿ�����  ;
               hap7 += retData._���ٹ���_������ؿܼҵ�;
               hap7 += retData._���ٹ���_������ʰ��ٹ�;
               hap7 += retData._���ٹ���_��Ÿ��������;

        retData._������ҵ� = hap7;

        // Ư��������(�Ǵ� ǥ�ذ���) �� ��� �ʿ�
        double hap  = retData._Ư������_�����  ;
               hap += retData._Ư������_�Ƿ��  ;
               hap += retData._Ư������_������  ;
//             2008.12      hap += retData._Ư������_�����ڱ�;
               hap += retData._Ư������_��α�  ;
			   //hap += retData._Ư������_�������  ;
			   hap += retData._Ư������_�����������Աݿ����ݻ�ȯ��; //2008.12
			   hap += retData._Ư������_�����ڱ����ڻ�ȯ��; //2008.12
			   hap += retData._Ư������_������; //2011.01
			   hap += retData._Ư������_�����������Ա����ڰ�����; //2013.01


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
               hap2 += retData._�߰�����_����Ծ�  ; //2008.12
               hap2 += retData._�߰�����_�Ѻθ���  ; //CSR ID:2013_9999

        //retData._�����ҵ�ݾ� = retData._�������ٷμҵ�ݾ� - hap2 ; //2011.01

        // Ư������_��α� ���
//        retData._Ư������_��α� = retData._Ư������_��α�1 + retData._Ư������_��α�2 ;

        // ���װ����հ� ���
        double hap3  = retData._���װ���_�ٷμҵ�       ;
               hap3 += retData._���װ���_�������Ա�     ;
               //hap3 += retData._���װ���_�ٷ����ֽ����� ;
               //hap3 += retData._�����������            ;
			   hap3 += retData._��ġ��α�					;
			   hap3 += retData._�������հ���					;
               hap3 += retData._���װ���_�ܱ�����       ;

        retData._���װ����հ� = hap3 ;



        // �ⳳ�μ����հ� ���
//        retData._�ⳳ�μ���_���ټ� += retData._���ٹ���_���μҵ漼;
//        retData._�ⳳ�μ���_�ֹμ� += retData._���ٹ���_�����ֹμ�;
//        retData._�ⳳ�μ���_��Ư�� += retData._���ٹ���_����Ư����;

     double hap5  = retData._�ⳳ�μ���_���ټ� ;
               hap5 += retData._�ⳳ�μ���_�ֹμ� ;
               hap5 += retData._�ⳳ�μ���_��Ư�� ;

        retData._�ⳳ�μ����հ� = hap5 ;
*/

        // ���������հ� ���
        double hap4  = retData._��������_���ټ� ;
               hap4 += retData._��������_�ֹμ� ;
               hap4 += retData._��������_��Ư�� ;

        retData._���������հ� = hap4 ;

        // [CSR ID:2778743]
        // ���������հ�_�� ���
        double hap7  = retData._��������_���ټ�_�� ;
               hap7 += retData._��������_�ֹμ�_�� ;
               hap7 += retData._��������_��Ư��_�� ;

        retData._���������հ�_�� = hap7 ;


        // ����¡�������հ� ���
        double hap6  = retData._����¡������_���ټ� ;
               hap6 += retData._����¡������_�ֹμ� ;
               hap6 += retData._����¡������_��Ư�� ;

        retData._����¡�������հ� = hap6 ;

        // [CSR ID:2778743]
        // ����¡�������հ�_�� ���
        double hap8  = retData._����¡������_���ټ�_�� ;
               hap8 += retData._����¡������_�ֹμ�_�� ;
               hap8 += retData._����¡������_��Ư��_�� ;

        retData._����¡�������հ�_�� = hap8 ;

        //[CSR ID:2778743]
        retData._����¡�������հ�_2014 = retData._����¡�������հ� - retData._����¡�������հ�_�� ;

//        retData._���ݺ�������_���� = retData._���ݺ������� + Data_P16 - Data_Y6N; //   "/Y6A+ /P16 - /Y6N" 20111.01


       //  Logger.debug.println(this, retData.toString());
 //Logger.debug.println(this, retData.toString());
        return retData ;
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput1(JCO.Function function) throws GeneralException {

    	// Export ���� ��ȸ
    	String fieldName1 = "E_RETTEXT";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_MESSAGE  = getField(fieldName1, function) ;

    	//Logger.debug.println(this, "function:"+function +"E_MESSAGE"+E_MESSAGE);
    	return E_MESSAGE;
    }

}