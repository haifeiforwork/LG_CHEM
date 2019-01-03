/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : �����ڱ� �űԽ�û �μ��� ����                               */
/*   Program Name : �����ڱ� �űԽ�û �μ��� ����                               */
/*   Program ID   : LoanData                                                    */
/*   Description  : ����� ����󼼳��� �������� ����Ÿ                         */
/*   Note         : [���� RFC] : ZHRA_RFC_GET_LOAN_DETAIL                       */
/*   Creation     : 2005-03-10  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.G;

import com.sns.jdf.EntityData;

public class LoanData extends EntityData {
    public String ZZRPAY_MNTH  ;  // ���� YYYYMM������ �Ⱓ(��ȯ�Ⱓ)
    public String TILBT        ;  // ���һ�ȯ(����ȯ����)
    public String REFN_BEGDA   ;  // ������(����ȯ����)
    public String REFN_ENDDA   ;  // ������(����ȯ����)
    public String MNTH_INTEREST;  // ����ȯ����
}
