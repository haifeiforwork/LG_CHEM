/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �����                                                    */
/*   Program Name : �򰡻��� ��ȸ                                               */
/*   Program ID   : B01ValuateDetailCheckRFC                                         */
/*   Description  : ����� �� ������ �����͵� �Ǵ��� Ȯ���ϴ�  RFC�� ȣ���ϴ� Class            */
/*   Note         : [���� RFC] : ZHRD_RFC_APPRAISAL_LIST  , ZHRW_RFC_CHECK_APPRAISAL                      */
/*   Creation     : 20141125 ������D   [CSR ID:2651528] �λ���� �߰� �� �޴���ȸ ��� ����                                      */
/*   Update       :  20150210  ������D [CSR ID:2703351] ¡�� ���� �߰� ����  : �߰� �� ���� üũ�ϋ��� 'A', ¡�� ��ȸ ���� üũ�϶��� 'B' ����Ʈ                                    */
/*                                                                              */
/********************************************************************************/

package hris.B.rfc ;

import com.common.constant.Area;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import org.apache.commons.lang.StringUtils;

public class B01ValuateDetailCheckRFC extends SAPWrap {

    private  static String functionName = "ZGHR_RFC_TABS_CHECK" ;

    /**
     * check tab
     * @param I_LOGPER
     * @param I_PERNR
     * @param I_TABGB
     * @param I_EMGUB
     * @param area
     * @return
     * @throws GeneralException
     */
    public String getValuateDetailCheck(String I_LOGPER, String I_PERNR, String I_TABGB, String I_EMGUB, Area area) throws GeneralException {
        if(!getSapType().isLocal()) {
            if(StringUtils.startsWith(I_TABGB, "A")) return "Y";
            else return "N";
        }
        return getValuateDetailCheck(I_LOGPER, I_PERNR, I_TABGB, I_EMGUB);
    }

    /**
     * ����� �� ������ �����͵� �Ǵ��� Ȯ���ϴ� RFC�� ȣ���ϴ� Method CSR ID:2703351
     * @param I_LOGPER  �α��� ���
     * @param I_PERNR  ��ȸ ���
     * @param I_TABGB �� ����
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */ 
    public String getValuateDetailCheck( String I_LOGPER, String I_PERNR, String I_TABGB, String I_EMGUB) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;
            /*
            I_TABGB		 NUMC 	 8 	�� ������
I_PERNR		 NUMC 	 8 	�����ȣ
I_LOGPER		NUMC	 8 	�α��� �����ȣ
I_DATUM		 DATS 	 8 	��������
I_SPRSL		 LANG 	 1 	���

A01	��
A02	¡��
A03	�ӿ�������༭

B01	��������
B02	���հ���(�̿�)
B03	�Ƿ��

             */
            setField(function, "I_TABGB", I_TABGB);
            setField(function, "I_LOGPER", I_LOGPER);
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_EMGUB", I_EMGUB);

            excute( mConnection, function ) ;

            return getField("E_FLAG", function);

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
}
