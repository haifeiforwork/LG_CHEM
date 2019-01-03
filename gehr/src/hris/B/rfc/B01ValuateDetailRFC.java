/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �����                                                    */
/*   Program Name : �򰡻��� ��ȸ                                               */
/*   Program ID   : B01ValuateDetailRFC                                         */
/*   Description  : ����� �� ������ �������� RFC�� ȣ���ϴ� Class            */
/*   Note         : [���� RFC] : ZHRD_RFC_APPRAISAL_LIST                        */
/*   Creation     : 2002-01-14  �Ѽ���                                          */
/*   Update       : 2005-01-11  ������                                          */
/*                      2018/05/21 rdcamel [CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��                                                       */
/********************************************************************************/

package hris.B.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.B.B01ValuateDetailData;

import java.util.Vector;

public class B01ValuateDetailRFC extends SAPWrap {

    private  static String functionName = "ZGHR_RFC_APPRAISAL_LIST" ;

    /** 
     * ����� �� ������ �������� RFC�� ȣ���ϴ� Method
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */ 
    public Vector<B01ValuateDetailData> getValuateDetail( String I_PERNR, String I_LEADER, String I_LPERNR, String I_CFORM, String I_REENTRY) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            /*
            I_PERNR		 NUMC 	 8 	�����ȣ
            I_MOLGA		CHAR	 2 	�����׷���
            I_DATUM		 DATS 	 8 	��������
            I_SPRSL		 DATS 	 8 	���
            I_PYEAR		 NUMC 	 4 	��ȸ ���ۿ���
            I_PTIMES		 INT 	 10 	�� ��ȸ�� LOOP CNT
            I_LEADER		 CHAR 	 1 	���忩��
            I_LPERNR		 NUMC 	 8 	 ������
             */
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_LEADER", I_LEADER);
            setField(function, "I_LPERNR", I_LPERNR);
            setField(function, "I_CFORM", I_CFORM);
            setField(function, "I_REENTRY", I_REENTRY);

            if("X".equals(I_CFORM))
                setField(function, "I_PTIMES", "20");


            excute( mConnection, function ) ;

            return getTable(B01ValuateDetailData.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    
    
    
    /**
     * ����� �� ������ �������� RFC�� ȣ���ϴ� Method(���� ��� ���� text �߰�����)
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     *  @author rdcamel [CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
     */ 
    public Vector<B01ValuateDetailData> getValuateDetailLong( String I_PERNR, String I_LEADER, String I_LPERNR, String I_CFORM, String I_REENTRY) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            /*
            I_PERNR		 NUMC 	 8 	�����ȣ
            I_MOLGA		CHAR	 2 	�����׷���
            I_DATUM		 DATS 	 8 	��������
            I_SPRSL		 DATS 	 8 	���
            I_PYEAR		 NUMC 	 4 	��ȸ ���ۿ���
            I_PTIMES		 INT 	 10 	�� ��ȸ�� LOOP CNT
            I_LEADER		 CHAR 	 1 	���忩��
            I_LPERNR		 NUMC 	 8 	 ������
             */
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_LEADER", I_LEADER);
            setField(function, "I_LPERNR", I_LPERNR);
            setField(function, "I_CFORM", I_CFORM);
            setField(function, "I_REENTRY", I_REENTRY);
            setField(function, "I_ORGKR", "X");//�λ��Ϻ� �� �ؿܹ��θ� �ѱ� ǥ�õǵ��� flag(�ش� ���� ������ ���θ� ������)

            if("X".equals(I_CFORM))
                setField(function, "I_PTIMES", "20");


            excute( mConnection, function ) ;

            return getTable(B01ValuateDetailData.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

}
