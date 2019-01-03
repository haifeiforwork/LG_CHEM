package hris.D.rfc ;

import java.math.BigDecimal;
import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 *  D15RetirementSimulRFC.java
 *  �����ݼҵ���� Simulation�� ���� �����ڷḦ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/02/06
 *                     2015/07/30 [CSR ID:2838889] ������ �ùķ��̼� ���ݷ��� ���� ��û�� ��
 */
public class D15RetirementSimulRFC extends SAPWrap {

   // private static String functionName = "ZHRP_RFC_SIM_CALC_RSGN_AMT" ;
	 private static String functionName = "ZGHR_RFC_SIM_CALC_RSGN_AMT" ;

    /**
     * �����ݼҵ���� Simulation�� ���� �����ڷḦ �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param empNo java.lang.String �����ȣ
     * @param I_DATE java.lang.String ������������
     * @exception com.sns.jdf.GeneralException
     */
    public Object getRetirementData( String empNo, String I_DATE ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, I_DATE);
            excute(mConnection, function);
            D15RetirementSimulData data = (D15RetirementSimulData)getOutput( function, new D15RetirementSimulData() );
            // ������� ���޾� �����ͼ� ����
            Vector code_vt = (Vector)getOutputTable(function);
            CodeEntity codeEnt = null;
            if( code_vt.size() > 0 ){
                codeEnt = (CodeEntity)code_vt.get(0);
                data.INS1_NAME1 = codeEnt.code;
                data.JON1_AMNT1 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }
            if( code_vt.size() > 1 ){
                codeEnt = (CodeEntity)code_vt.get(1);
                data.INS1_NAME2 = codeEnt.code;
                data.JON1_AMNT2 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }
            if( code_vt.size() > 2 ){
                codeEnt = (CodeEntity)code_vt.get(2);
                data.INS1_NAME3 = codeEnt.code;
                data.JON1_AMNT3 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );

                Logger.debug.println(this,"[�����ݽùķ��̼�] ����簡 2���̻��Դϴ�.???");
            }
            if( code_vt.size() > 3 ){
                codeEnt = (CodeEntity)code_vt.get(3);
                data.INS1_NAME4 = codeEnt.code;
                data.JON1_AMNT4 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }
            if( code_vt.size() > 4 ){
                codeEnt = (CodeEntity)code_vt.get(4);
                data.INS1_NAME5 = codeEnt.code;
                data.JON1_AMNT5 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 5 ){
                codeEnt = (CodeEntity)code_vt.get(5);
                data.INS1_NAME6 = codeEnt.code;
                data.JON1_AMNT6 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 6 ){
                codeEnt = (CodeEntity)code_vt.get(6);
                data.INS1_NAME7 = codeEnt.code;
                data.JON1_AMNT7 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 7 ){
                codeEnt = (CodeEntity)code_vt.get(7);
                data.INS1_NAME8 = codeEnt.code;
                data.JON1_AMNT8 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 8 ){
                codeEnt = (CodeEntity)code_vt.get(8);
                data.INS1_NAME9 = codeEnt.code;
                data.JON1_AMNT9 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 9 ){
                codeEnt = (CodeEntity)code_vt.get(9);
                data.INS1_NAME10 = codeEnt.code;
                data.JON1_AMNT10 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }
            DataUtil.fixNull(data);

            Logger.debug.println(this, data.toString());

            data.WAGE_AVER =Double.toString(Double.parseDouble(data.WAGE_AVER) * 100.0 ); // ����ӱ�
            data.GRNT_RSGN =Double.toString(Double.parseDouble(data.GRNT_RSGN) * 100.0 ); // �������Ѿ�
            //data.O_ZIPY01  =Double.toString(Double.parseDouble(data.O_ZIPY01 ) * 100.0 ); // ��������޾�1
            //data.O_ZIPY02  =Double.toString(Double.parseDouble(data.O_ZIPY02 ) * 100.0 ); // ��������޾�2
            data.O_BONDM   =Double.toString(Double.parseDouble(data.O_BONDM  ) * 100.0 ); // ä�ǰ��з�����
            data.O_HLOAN   =Double.toString(Double.parseDouble(data.O_HLOAN  ) * 100.0 ); // �����ڱݰ���
            data.O_NAPPR   =Double.toString(Double.parseDouble(data.O_NAPPR  ) * 100.0 ); // ������ȯ��
            data.INC_TAX   =Double.toString(Double.parseDouble(data.INC_TAX  ) * 100.0 ); // [CSR ID:2838889] �������ټ�
            data.RES_TAX   =Double.toString(Double.parseDouble(data.RES_TAX  ) * 100.0 ); // [CSR ID:2838889] �����ֹμ�

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
     * @param I_DATE java.lang.String ������������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String I_DATE ) throws GeneralException {
        //String fieldName1 = "PERNR";
    	String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_DATE";
        setField( function, fieldName2, I_DATE );
    }

// Export Return type�� Object �� ��� 2
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC ������ Export ���� Object �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        //return getFields(data, function);
    	return getExportFields(data, function,"");
    }
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutputTable(JCO.Function function) throws GeneralException {
        //String tableName  = "ZHRPI00S";      // RFC Export ������� ����
    	String tableName  = "T_ZHRPI00S";      // RFC Export ������� ����
        String codeField  = "INS1_NAME";
        String valueField = "JON1_AMNT";
        return getCodeVector( function, tableName, codeField, valueField );
    }

    /**
     * �����ݼҵ���� Simulation�� ���� �����ڷḦ �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param empNo java.lang.String �����ȣ
     * @param beginDate java.lang.String ������
     * @param endDate java.lang.String ������
     * @exception com.sns.jdf.GeneralException
     */
    public Object simulate( D15RetirementSimulData data ) throws GeneralException {
        try{
            double _�������Ѿ�     = Double.parseDouble(data.GRNT_RSGN );
            //double _��������     = Double.parseDouble(data._�������� );  // ????????? ���������� �������Ѿ׿� ���ԵǾ��ִٴ� ����..
            double _������ȯ��     = Double.parseDouble(data.O_NAPPR   );
            double _��������޾�1  = Double.parseDouble(data.JON1_AMNT1.equals("")?"0":data.JON1_AMNT1);
            double _��������޾�2  = Double.parseDouble(data.JON1_AMNT2.equals("")?"0":data.JON1_AMNT2);
            double _��������޾�3  = Double.parseDouble(data.JON1_AMNT3.equals("")?"0":data.JON1_AMNT3);
            double _��������޾�4  = Double.parseDouble(data.JON1_AMNT4.equals("")?"0":data.JON1_AMNT4);
            double _��������޾�5  = Double.parseDouble(data.JON1_AMNT5.equals("")?"0":data.JON1_AMNT5);
            double _��������޾�6  = Double.parseDouble(data.JON1_AMNT6.equals("")?"0":data.JON1_AMNT6);
            double _��������޾�7  = Double.parseDouble(data.JON1_AMNT7.equals("")?"0":data.JON1_AMNT7);
            double _��������޾�8  = Double.parseDouble(data.JON1_AMNT8.equals("")?"0":data.JON1_AMNT8);
            double _��������޾�9  = Double.parseDouble(data.JON1_AMNT9.equals("")?"0":data.JON1_AMNT9);
            double _��������޾�10  = Double.parseDouble(data.JON1_AMNT10.equals("")?"0":data.JON1_AMNT10);
            double _ä�ǰ��з����� = Double.parseDouble(data.O_BONDM   );
            double _�����ڱݰ���   = Double.parseDouble(data.O_HLOAN   );
            double _�������ټ� = 0.0;
            double _�����ֹμ� = 0.0;
            double _�������޾� = 0.0;
            double _�����Ѿ�   = 0.0;

            double _�����ҵ����     = 0.0;
            double _�����ҵ����ǥ�� = 0.0;
            double _�⺻����         = 0.0;
            double _�����ҵ���⼼�� = 0.0;
            double _�����ҵ漼�װ��� = 0.0;
            double _�����ҵ�������� = 0.0;

            //double _��������հ���ǥ�� = 0.0;
            double _��������ջ��⼼�� = 0.0;

            double MANWON = 10000.0 ; // ��ȭ ����
            // �ټӳ�� ����
            int financeYear = Integer.parseInt(data.fu_retireDate.substring(0,4));
            int workYear = Integer.parseInt(data.SERV_PROD_Y);
            if( Integer.parseInt(data.SERV_PROD_M) > 0 ){
                workYear += 1;
            }
            Logger.debug.println(this,"Retirement Simulating... �����⵵ : "+financeYear+", �ټӳ⵵ : "+workYear);
           /*------------  �������ټ� ��� -----------------------*/
            // �����ҵ���� ��� @2011����
            _�����ҵ����  = _�������Ѿ� * 0.4 ;
            //_�����ҵ����  = (_�������Ѿ� - _��������) * 0.5 ;
            //_�����ҵ���� += _��������  * 0.75 ;
            if(workYear > 0 && workYear <= 5){
                _�����ҵ���� += (double)workYear * 30*MANWON;        // 1��� 30����
            } else if(workYear > 5 && workYear <= 10){
                _�����ҵ���� += 150*MANWON + (double)(workYear - 5)*50*MANWON;
            } else if(workYear > 10 && workYear <= 20){
                _�����ҵ���� += 400*MANWON + (double)(workYear - 10)*80*MANWON;
            } else if(workYear > 20){
                _�����ҵ���� += 1200*MANWON + (double)(workYear - 20)*120*MANWON;
            }

            // �����ҵ����ǥ�� = �����޿� - �����ҵ����
            _�����ҵ����ǥ�� = _�������Ѿ� - _�����ҵ����;

            //_��������հ���ǥ�� = _�����ҵ����ǥ�� / (double)workYear;

            Logger.debug.println(this,"####_�����ҵ���� : "+_�����ҵ����+", _�����ҵ����ǥ�� : "+_�����ҵ����ǥ��);

            // �⺻���� ���
            /*
            if( _��������հ���ǥ�� > 0 && _��������հ���ǥ�� <= ( 1000*MANWON ) ){
                _�⺻���� = 0.09 ;
            } else if( (_��������հ���ǥ�� > ( 1000*MANWON )) && (_��������հ���ǥ�� <= ( 4000*MANWON )) ){
                _�⺻���� = 0.18 ;
            } else if( (_��������հ���ǥ�� > ( 4000*MANWON )) && (_��������հ���ǥ�� <= ( 8000*MANWON )) ){
                _�⺻���� = 0.27 ;
            } else if( _��������հ���ǥ�� > ( 8000*MANWON ) ){
                _�⺻���� = 0.36 ;
            }
            // @2011����    ����ǥ��	����
            //12,000,000	6%
            //46,000,000	15%
            //88,000,000	24%
            // 	35%
            if( _��������հ���ǥ�� > 0 && _��������հ���ǥ�� <= ( 1200*MANWON ) ){
                _�⺻���� = 0.06 ;
            } else if( (_��������հ���ǥ�� > ( 1200*MANWON )) && (_��������հ���ǥ�� <= ( 4600*MANWON )) ){
                _�⺻���� = 0.15 ;
            } else if( (_��������հ���ǥ�� > ( 4600*MANWON )) && (_��������հ���ǥ�� <= ( 8800*MANWON )) ){
                _�⺻���� = 0.24 ;
            } else if( _��������հ���ǥ�� > ( 8800*MANWON ) ){
                _�⺻���� = 0.35 ;
            }*/

            /* 2013.04 �������� */
            /*
            _��������ջ��⼼�� =  (_��������հ���ǥ�� * _�⺻����);
            BigDecimal calYearRate = new BigDecimal(_��������ջ��⼼��).setScale(0, BigDecimal.ROUND_FLOOR);  //�Ҽ������� ����
            _��������ջ��⼼�� = Double.parseDouble( calYearRate.toString());//�����ڸ����� ����

            // �����ҵ���⼼�� = �����ҵ����ǥ�� / �ټӿ��� * �⺻����(10~40%) * �ټӿ���
            _�����ҵ���⼼�� = _��������ջ��⼼�� * (double)workYear;
            BigDecimal calRate = new BigDecimal(_�����ҵ���⼼��*0.1).setScale(0, BigDecimal.ROUND_FLOOR);  //�����ڸ����� ����
            _�����ҵ���⼼�� = Double.parseDouble( calRate.toString())*10;//�����ڸ����� ����

            */

            //2013.04.05 �����ȹݿ�=====start =================
            //�� �ټӿ���(2013��1��1�����ıټӿ���)
            int Aftr2013Mon= (Integer.parseInt(data.fu_retireDate.substring(0,4))-2012-2)*12
                                +(12+12-Integer.parseInt(data.O_GIDAT.substring(5,7)) + Integer.parseInt(data.fu_retireDate.substring(4,6))+1);//20150819 5,7 -> 4,6 ����
            int Aftr2013Year = Aftr2013Mon/12; //�� �ټӿ���(2013��1��1�����ıټӳ��)
            int Prev2013Year = workYear-Aftr2013Year; //�� �ټӿ���(2013��1��1�������ټӳ��)

            Logger.debug.println(this, "workYear:"+workYear+  "Aftr2013Mon : "+Aftr2013Mon+ "  Aftr2013Year : "+Aftr2013Year+ "  Prev2013Year : "+Prev2013Year);

            //<2012.12.31����>
            //z-1 ����ǥ�ؾȺ� =  d ��������� ����ǥ��*�� �ټӿ���(2012�������ټӳ��)/����ټӿ���
            //d -1 ��������հ���ǥ��=����ǥ�ؾȺ�/�� �ټӿ���
            //����ջ��⼼��=��������հ���ǥ��*����
            //���⼼��=����ջ��⼼��*�� �ټӿ���

            double _Prev2013����ǥ�ؾȺ� = 0.0;
            double _Prev2013��������հ���ǥ�� = 0.0;
            double _Prev2013����ջ��⼼�� = 0.0;
            double _Prev2013���⼼�� = 0.0;

            /*_Prev2013����ǥ�ؾȺ� = _��������հ���ǥ��*Prev2013Year/workYear;
            if(Prev2013Year == 0){
            	_Prev2013��������հ���ǥ�� = 0;
            }else{
            	_Prev2013��������հ���ǥ�� = _Prev2013����ǥ�ؾȺ�/Prev2013Year;
            }
            _Prev2013����ջ��⼼�� = _Prev2013��������հ���ǥ�� * _�⺻����;
            _Prev2013���⼼�� = _Prev2013����ջ��⼼�� * Prev2013Year;
            */
            double _Aftr2013����ǥ�ؾȺ� = 0.0;
            double _Aftr2013��������հ���ǥ�� = 0.0;
            double _Aftr2013����ջ��⼼�� = 0.0;
            double _Aftr2013ȯ�����ǥ�� = 0.0;
            double _Aftr2013ȯ����⼼�� = 0.0;
            double _Aftr2013���⼼�� = 0.0;

            //<2013.01.01����>
            //z-2 ����ǥ�ؾȺ�= d ��������� ����ǥ��*���ټӿ���(2012�����ıټӳ��)/����ټӿ���
            //d -2 ��������հ���ǥ��=����ǥ�ؾȺ�/�� �ټӿ���
           // e ȯ�����ǥ��=d-2��������հ���ǥ��*5
            //ȯ����⼼��=e ȯ�����ǥ��*����
            //����ջ��⼼��=ȯ����⼼��/5
            //���⼼��=����ջ��⼼��*�� �ټӿ���

            /*_Aftr2013����ǥ�ؾȺ� = _��������հ���ǥ��*Aftr2013Year/workYear;
            _Aftr2013��������հ���ǥ�� = _Aftr2013����ǥ�ؾȺ�/Aftr2013Year;
            _Aftr2013ȯ�����ǥ�� = _Aftr2013��������հ���ǥ��*5;
            _Aftr2013ȯ����⼼�� = _Aftr2013ȯ�����ǥ�� * _�⺻����;
            _Aftr2013����ջ��⼼�� = _Aftr2013ȯ����⼼��/5;
            _Aftr2013���⼼�� = _Aftr2013����ջ��⼼�� * Aftr2013Year;

*/
        //    _�����ҵ���⼼�� = _Prev2013���⼼�� +_Aftr2013���⼼��;

            //2013.04.05 �����ȹݿ� end======================

            BigDecimal calRate = new BigDecimal(_�����ҵ���⼼��*0.1).setScale(0, BigDecimal.ROUND_FLOOR);  //�����ڸ����� ����
            _�����ҵ���⼼�� = Double.parseDouble( calRate.toString())*10;//�����ڸ����� ����

            Logger.debug.println(this, "  calRate : "+calRate);

            Logger.debug.println(this,"####_�⺻���� : "+_�⺻����+", _�����ҵ���⼼�� : "+_�����ҵ���⼼��);

            // �����ҵ漼�װ��� ���
            double limit = 0  ;
            double resultTax = 0 ;
            if(financeYear < 2003){
                limit = 24*MANWON * workYear ;
                resultTax = (_�����ҵ���⼼�� * 0.5);

            } else if(financeYear == 2003 || financeYear == 2004){
                limit = 12*MANWON * workYear ;
                resultTax = (_�����ҵ���⼼�� * 0.25);

            } else if(financeYear >= 2005){
                limit = 0 ;
                resultTax = 0 ;
            }

            Logger.debug.println(this,"####limit : "+limit+", resultTax : "+resultTax);

            _�����ҵ漼�װ��� = ((resultTax > limit) ? limit : resultTax);

            // �����ҵ�������� = �����ҵ���⼼�� - �����ҵ漼�װ���
            _�����ҵ�������� = _�����ҵ���⼼�� - _�����ҵ漼�װ��� ;

//            _�������ټ� = DataUtil.nelim( _�����ҵ�������� ,-1);
            _�������ټ� = _�����ҵ��������;

            //[CSR ID:2838889] ������ �ùķ��̼� ���ݷ��� ���� ��û�� ��
            //data._�������ټ� = Double.toString(_�������ټ�);
            data._�������ټ� = data.INC_TAX;//
           /*------------  �������ټ� ��� End -----------------------*/

            // �����ֹμ� ���
//            _�����ֹμ� = DataUtil.nelim( (_�������ټ� * 0.1) ,-1);
             _�����ֹμ� = (_�������ټ� * 0.1);
            BigDecimal calJumin = new BigDecimal(_�����ֹμ�*0.1).setScale(0, BigDecimal.ROUND_FLOOR);  //�����ڸ����� ����
            _�����ֹμ� = Double.parseDouble( calJumin.toString())*10;//�����ڸ����� ����

            //data._�����ֹμ� = Double.toString(_�����ֹμ�);
            data._�����ֹμ� = data.RES_TAX;


            // �����Ѿ�  ���
//          [CSR ID:2838889] ������ �ùķ��̼� ���ݷ��� ���� ��û�� ��
            //_�����Ѿ� = _�������ټ� + _�����ֹμ� + _������ȯ�� + _ä�ǰ��з����� + _�����ڱݰ���;
            _�����Ѿ� = Double.parseDouble(data._�������ټ�) + Double.parseDouble(data._�����ֹμ�) + _������ȯ�� + _ä�ǰ��з����� + _�����ڱݰ���;
            data._�����Ѿ� = Double.toString(_�����Ѿ�);
            // �������޾� ���
            _�������޾� = _�������Ѿ� - _�����Ѿ� ;
            data._�������޾� = Double.toString(_�������޾�);
            // ȸ�翡�� �����ϴ� �ݾ� ���
            data._ȸ�����޾� = Double.toString(_�������Ѿ� - _��������޾�1 - _��������޾�2 - _��������޾�3 - _��������޾�4 - _��������޾�5- _��������޾�6 - _��������޾�7 - _��������޾�8 - _��������޾�9 - _��������޾�10) ;
            return data;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
}