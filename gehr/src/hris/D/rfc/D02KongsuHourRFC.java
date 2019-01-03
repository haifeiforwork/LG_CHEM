package hris.D.rfc ;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D01OT.D01OTData;

/**
 * D02KongsuHourRFC.java
 * ���� �������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2012/06/14
 *                2.0 2015/06/18 [CSR ID:2803878] �ʰ��ٹ� ��û Process ���� ��û
 *                2016/04/29 [CSR ID:3043406] �޿���ǥ �� ���� ��Ȳ ���� ���� ��û
 */
public class D02KongsuHourRFC  extends SAPWrap {

    private String functionName = "ZGHR_RFC_CALC_KONGSU_HOUR" ;

    /**
     * ���� ������ �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getHour( String empNo, String YYYYMM ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM) ;
            excute( mConnection, function ) ;

            String ret = getOutput( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }


    /**
     * ���� ������ �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     *  [CSR ID:3043406] �޿���ǥ �� ���� ��Ȳ ���� ���� ��û
     */
    public Vector getHour2( String empNo, String YYYYMM ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput4( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    /**
     * �ʰ��ٹ� ������ �������� RFC�� ȣ���ϴ� Method(�ʰ��ٹ� ��Ȳ ��ȸ)
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getOvtmHour( String empNo, String YYYYMM, String iFlag ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM, iFlag) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput1( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }


    /** [WorkTime52]
     * �ʰ��ٹ� ������ �������� RFC�� ȣ���ϴ� Method(�ʰ��ٹ� ��Ȳ ��ȸ)
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getOvtmHour2( String empNo, String I_DATE, String iFlag , String I_NTM ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput2( function, empNo, I_DATE, iFlag, I_NTM) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput1( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }





    /**
     * �ʰ��ٹ� ������ �������� RFC�� ȣ���ϴ� Method(��û �� ȣ��)
     *  @param   java.lang.String �����ȣ
     *  @param  	java.lang.String iFlag  : 'C' = ��Ȳ, 'R' = ��û,'M' = ����, 'G' = ����
     *  @return   java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getOvtmHour( String empNo, String YYYYMM,  String iFlag,  D01OTData inputData ) throws GeneralException {
        JCO.Client mConnection = null ;

//PERNR,yymm,inputData.WORK_DATE,"R", inputData.AINF_SEQN,
//		inputData.STDAZ, inputData.PBEG1, inputData.PEND1, inputData.PBEG2, inputData.PEND2
//String empNo, String YYYYMM, String DATE, String iFlag, String AINF_SEQN,
        //String workTime, String restFrom1, String restTo1, String restFrom2, String restTo2

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM, inputData.WORK_DATE, iFlag, inputData.AINF_SEQN, inputData.STDAZ,
            		inputData.PBEG1, inputData.PEND1, inputData.PBEG2, inputData.PEND2) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput2( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    /**********************************************************************************************************/
    /** [WorkTime52]
     * �ʰ��ٹ� ������ �������� RFC�� ȣ���ϴ� Method(��û �� ȣ��)
     *  @param   java.lang.String �����ȣ
     *  @param  	java.lang.String iFlag  : 'C' = ��Ȳ, 'R' = ��û,'M' = ����, 'G' = ����
     *  @return   java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getOvtmHour52( String empNo, String YYYYMMDD,  String iFlag,  D01OTData inputData, String I_NTM ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput52( function, empNo, YYYYMMDD, inputData.WORK_DATE, iFlag, inputData.AINF_SEQN, inputData.STDAZ,
            		inputData.PBEG1, inputData.PEND1, inputData.PBEG2, inputData.PEND2, I_NTM) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput2( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**********************************************************************************************************/

    /**
     * �ʰ��ٹ� ������ �������� RFC�� ȣ���ϴ� Method(���ϱ��� üũ ���� ���� Ȯ�� ��)
     *  @param     java.lang.String �����ȣ
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getOvtmHour( String empNo, String YYYYMM, String DATE, String temp) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM, DATE, temp) ;
            excute( mConnection, function ) ;

            String ret = getOutput3( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception      com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String empNo, String YYYYMM ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMM" ;
        setField( function, fieldNam1, YYYYMM ) ;

    }

    /**
     * [CSR ID:2803878] �ʰ��ٹ� ���� ���� ����
     * ȭ�鿡 ���� ��û �ð��� ������
     */
    private void setInput( JCO.Function function, String empNo, String YYYYMM, String iFlag ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMM" ;
        setField( function, fieldNam1, YYYYMM ) ;//���� ���

        String fieldNam2 = "I_FLAG" ; // C : ��Ȳ, R : ��û
        setField( function, fieldNam2, iFlag ) ;
    }



    /** [WorkTime52]
     * [CSR ID:2803878] �ʰ��ٹ� ���� ���� ����
     * ȭ�鿡 ���� ��û �ð��� ������
     */
    private void setInput2( JCO.Function function, String empNo, String I_DATE, String iFlag, String I_NTM ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_DATE" ;
        setField( function, fieldNam1, I_DATE ) ;//�������� �� �ʰ��ٹ���û��

        String fieldNam2 = "I_FLAG" ; // C : ��Ȳ, R : ��û
        setField( function, fieldNam2, iFlag ) ;

        String fieldNam3 = "I_NTM" ; // �ű� ���� optional value
        setField( function, fieldNam3, I_NTM ) ;

    }








    /**
     * [CSR ID:2803878] �ʰ��ٹ� ���� ���� ����
     * ȭ�鿡 ���� ��û �ð��� ������
     */
    private void setInput( JCO.Function function, String empNo, String YYYYMM, String DATE, String iFlag, String AINF_SEQN, String workTime, String restFrom1, String restTo1, String restFrom2, String restTo2 ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMM" ;
        setField( function, fieldNam1, YYYYMM ) ;//���� ���

        String fieldNam2 = "I_DATE" ; // ��û��(�ش� ���ڰ� ���Ե� ���� �ʰ��ٹ� ��û �հ踦 �˱� ����
        setField( function, fieldNam2, DATE ) ;

        String fieldNam3 = "I_FLAG" ; // C : ��Ȳ, R : ��û,  M : ����, G : ����
        setField( function, fieldNam3, iFlag ) ;

        String fieldNam9 = "I_AINF_SEQN" ; // �����ȣ(����, ������ ��츸 ����)
        setField( function, fieldNam9, AINF_SEQN ) ;

        String fieldName4 = "I_STDAZ" ;
        setField( function, fieldName4, workTime ) ;//�ٹ��ϴ� �ð�

        String fieldNam5 = "I_PBEG1" ;
        setField( function, fieldNam5, restFrom1 ) ;//�޽Ľð� from 1

        String fieldNam6 = "I_PEND1" ; // �޽Ľð� to 1
        setField( function, fieldNam6, restTo1 ) ;

        String fieldNam7 = "I_PBEG2" ; // �޽Ľð� from 2
        setField( function, fieldNam7, restFrom2 ) ;

        String fieldNam8 = "I_PEND2" ; //�޽Ľð� to 2
        setField( function, fieldNam8, restTo2 ) ;
    }




    /** [WorkTime52]
     * [CSR ID:2803878] �ʰ��ٹ� ���� ���� ����
     * ȭ�鿡 ���� ��û �ð��� ������
     */
    private void setInput52( JCO.Function function, String empNo, String YYYYMMDD, String DATE, String iFlag, String AINF_SEQN, String workTime, String restFrom1, String restTo1, String restFrom2, String restTo2, String I_NTM ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMMDD" ;
        setField( function, fieldNam1, YYYYMMDD ) ;//���� ���

        String fieldNam2 = "I_DATE" ; // ��û��(�ش� ���ڰ� ���Ե� ���� �ʰ��ٹ� ��û �հ踦 �˱� ����
        setField( function, fieldNam2, DATE ) ;

        String fieldNam3 = "I_FLAG" ; // C : ��Ȳ, R : ��û,  M : ����, G : ����
        setField( function, fieldNam3, iFlag ) ;

        String fieldNam9 = "I_AINF_SEQN" ; // �����ȣ(����, ������ ��츸 ����)
        setField( function, fieldNam9, AINF_SEQN ) ;

        String fieldName4 = "I_STDAZ" ;
        setField( function, fieldName4, workTime ) ;//�ٹ��ϴ� �ð�

        String fieldNam5 = "I_PBEG1" ;
        setField( function, fieldNam5, restFrom1 ) ;//�޽Ľð� from 1

        String fieldNam6 = "I_PEND1" ; // �޽Ľð� to 1
        setField( function, fieldNam6, restTo1 ) ;

        String fieldNam7 = "I_PBEG2" ; // �޽Ľð� from 2
        setField( function, fieldNam7, restFrom2 ) ;

        String fieldNam8 = "I_PEND2" ; //�޽Ľð� to 2
        setField( function, fieldNam8, restTo2 ) ;

        String fieldNam10 = "I_NTM" ; //�޽Ľð� to 2
        setField( function, fieldNam10, I_NTM ) ;
    }


















    /**
     * [CSR ID:2803878] �ʰ��ٹ� ���� ���� ����
     * ȭ�鿡 ���� ��û �ð��� ������
     */
    private void setInput( JCO.Function function, String empNo, String YYYYMM, String I_DATE, String temp ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMM" ;
        setField( function, fieldNam1, YYYYMM ) ;//���� ���

        String fieldNam2 = "I_DATE" ; //
        setField( function, fieldNam2, I_DATE ) ;
    }



    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @@�޿����� ���� ���� ���� �� function@@
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private String getOutput( JCO.Function function ) throws GeneralException {
//      Export ���� ��ȸ
        String fieldName1      = "E_KONGSU_HOUR";      // ���ٿ�����
        String P_KONGSU_HOUR   = getField(fieldName1, function) ;

        Logger.sap.println( this, " P_KONGSU_HOUR : " + P_KONGSU_HOUR ) ;
        return P_KONGSU_HOUR;
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @@ȭ�� ó�� �ε��� �� �⺻ ������ �ҷ����� function@@
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput1( JCO.Function function ) throws GeneralException {

    	Vector ret = new Vector();
    	//      Export ���� ��ȸ
        String fieldName      = "E_KONGSU_HOUR";      // ���ٿ�����
        String P_KONGSU_HOUR   = getField(fieldName, function) ;

        //[CSR ID:2803878] �ʰ��ٹ� ���� ������
        String fieldName1      = "E_YUNJANG";      // ���Ͽ���
        String YUNJANG   = getField(fieldName1, function) ;
        String fieldName2      = "E_HTKGUN";      // ���ϱٷ�
        String HTKGUN   = getField(fieldName2, function) ;
        String fieldName3      = "E_HYUNJANG";      // ���Ͽ���
        String HYUNJANG   = getField(fieldName3, function) ;
        String fieldName4      = "E_YAGAN";      // �߰��ٷ�
        String YAGAN   = getField(fieldName4, function) ;
        String fieldName5      = "E_NOAPP";      // �̰��� �׸�
        String NOAPP   = getField(fieldName5, function) ;

        // [KJI2015042703] �ʰ��ٹ� ����
        String fieldName6      = "E_MONTH";      //��Ȳ ��ܿ� �� ǥ��(���� 21 ~ �� �� 20)
        String MONTH   = getField(fieldName6, function) ;

        ret.addElement(P_KONGSU_HOUR);
        ret.addElement(YUNJANG);
        ret.addElement(HTKGUN);
        ret.addElement(HYUNJANG);
        ret.addElement(YAGAN);
        ret.addElement(NOAPP);
        ret.addElement(MONTH);

        return ret;
    }

    /**
    * RFC ������ Export ���� Vector �� Return �Ѵ�.
    * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
    * @@��û ��ư ���� �� Ÿ�� function@@
    * @param function com.sap.mw.jco.JCO.Function
    * @return         java.util.Vector
    * @exception      com.sns.jdf.GeneralException
    */
   private Vector getOutput2( JCO.Function function ) throws GeneralException {

	   Vector ret = new Vector();
   	//      Export ���� ��ȸ
       String fieldName      = "E_YN_FLAG";      // 'Y' = 12�ð� �̸�, 'N' = 12�ð� �̻� (��û�� ������ �ֿ� ��û�� total �ʰ��ٹ� ��û�ð�)
       String YN_FLAG   = getField(fieldName, function) ;

       //��û�ϰ� �ִ� ������ ���� �����Ͽ� �������� ��� �ִ�(��~��) �ʰ��ٹ� �ð�, �繫���� ��� ����(���� 21���� �̹� �� 20�� ����) �ʰ��ٹ� �ð� ��û�� �� ���� ���
       String fieldName1 = "E_SUM";
       String SUM = getField(fieldName1, function);

       //��û�ڰ� �繫������ ���������� �����ϴ� flag(������ : P, �繫�� : O)
       String fieldName2 = "E_PERSON_FLAG";
       String PERSON_FLAG = getField(fieldName2, function);

       //���� ���¿� ���� üũ�ڽ��� �ص� �Ǵ� ������� üũ(N�� ��� ��û �Ұ������.)
       String filedName3 = "E_PRECHECK";
       String PRECHECK = getField(filedName3, function);

       String fieldName4      = "E_MONTH";      // ��û/���� �� popup�� ��û�� �������� �� ǥ��
       String MONTH   = getField(fieldName4, function) ;

       ret.addElement(YN_FLAG);
       ret.addElement(SUM);
       ret.addElement(PERSON_FLAG);
       ret.addElement(PRECHECK);
       ret.addElement(MONTH);

       return ret;
   }

   /**
    * RFC ������ Export ���� Vector �� Return �Ѵ�.
    * �ݵ�� com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
    * @@��û ��ư ���� �� Ÿ�� function@@
    * @param function com.sap.mw.jco.JCO.Function
    * @return         java.util.Vector
    * @exception      com.sns.jdf.GeneralException
    */
   private String getOutput3( JCO.Function function ) throws GeneralException {
   	//      Export ���� ��ȸ
       String fieldName   = "E_PRECHECK";
       String PRECHECK = getField(fieldName, function);

       return PRECHECK;
   }

   //[CSR ID:3043406] �޿���ǥ �� ���� ��Ȳ ���� ���� ��û
   private Vector getOutput4( JCO.Function function ) throws GeneralException {
	   Vector ret = new Vector();
//     Export ���� ��ȸ
       String fieldName1      = "E_KONGSU_HOUR";      // �ð�����
       String P_KONGSU_HOUR   = getField(fieldName1, function) ;
       String fieldName2      = "E_KONGSU_HOUR2";      // �ݾװ���
       String E_KONGSU_HOUR2   = getField(fieldName2, function) ;

       ret.addElement(P_KONGSU_HOUR);
       ret.addElement(E_KONGSU_HOUR2);

       Logger.sap.println( this, " P_KONGSU_HOUR : " + P_KONGSU_HOUR ) ;
       return ret;
   }

}
