package	hris.A.A13Address;

import com.common.constant.Area;

/**
 * A13AddressListData.java
 * ������ �ּ� ������ ��ƿ��� ������
 *   [���� RFC] : ZHRE_RFC_ADDRESS_LIST
 * 
 * @author �赵��    
 * @version 1.0, 2001/12/26
 */
public class A13AddressListData extends com.sns.jdf.EntityData {

    public String SUBTY    ;   // �Ϻ�����
    public String STEXT    ;   // �Ϻ�������
    public String LAND1    ;   // �����ڵ�
    public String LANDX    ;   // ������
    public String PSTLZ    ;   // �����ȣ
    public String STRAS    ;   // �ּ�
    public String LOCAT    ;   // �ι�° �ּ�
    public String TELNR    ;   // ��ȭ��ȣ
    public String LIVE_TYPE;   // �ְ������ڵ�
    public String LIVE_TEXT;   // �ְ����¸�

    /* �ؿ� */
    public String BEGDA    ;   //
    public String ENDDA    ;   //
    public String ANSSA    ;   //
    public String ANSTX    ;   //
    public String ADRES    ;   //
    public String NAME2    ;   //
    public String ORT01    ;   //
    public String ORT02    ;   //
    public String HSNMR    ;   //
    public String STATE    ;   //
    public String BEZEI    ;   //
    public String POSTA    ;   //
    public String COUNC    ;   //
    public String BEZEI1    ;   //
    public String ADRTW    ;   //
    public String VILLA    ;
    public String NEIGH  ;
    public String BEZEI2    ;
    public String TOWN ;

    /* DE */
    public String OR2KK ; //post
    public String ENTKM; //Distance in Km.
    public String TERY0; //District key
    public String TERY1; //District key
    public String TERY2;
    public String RCTVC; //District key
    public String TTEXT; //District key
    public String BLAND;
    public String PERNR;
    public String AINF_SEQN ;   //�������� �Ϸù�ȣ
    public String ZPERNR    ;   //�븮��û�� ���
    public String AEDTM     ;   //������
    public String UNAME     ;   //������̸�
    public String CERT_FLAG ;   //����
    public String CERT_DATE ;   //����������
    public String ZUNAME;

    public String ACOLOR;   //������ - â������� ���� �ӽ�

    public String address;
    public String getAddress(Area area) {
        if(area == Area.KR) return STRAS + "&nbsp;" + LOCAT;
        //<%= data.ORT01 %>��<%= data.ORT02 %>��<%= data.LOCAT %>�� <%= data.STRAS %>��<%= data.HSNMR %>��<%= data.POSTA %>
        else if(area == Area.CN)    //28
            return ORT01  + "��" + ORT02  + "��" + LOCAT  + "�� " + STRAS  + "��" + HSNMR  + "��" + POSTA;
        //<%= data.NAME2 %>��<%= data.STRAS %><%= data.LOCAT %>��<%= data.ORT01 %>����<%= data.COUNC %>��<%= data.STATE %>��<%= data.LAND1 %>��</td>
        else if(area == Area.HK)    //27
            return NAME2  + "��" + STRAS + LOCAT  + "��" + ORT01 +"����"+ COUNC  + "��" + STATE  + "��" + LAND1;
        // <%= data.BEZEI %>��<%= data.BEZEI1 %>��<%= data.STRAS %>��<%= data.VILLA %>��<%= data.NEIGH %>
        else if(area == Area.TW)    //42
            return BEZEI  + "��" + BEZEI1  + "��" + STRAS  + "��" + VILLA  + "��" + NEIGH;

        return ADRES;
    }

    public void setAddress(Area area) {
        address = getAddress(area);
    }

    public String getSUBTY() {
        return SUBTY;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public String getLAND1() {
        return LAND1;
    }

    public String getLANDX() {
        return LANDX;
    }

    public String getPSTLZ() {
        return PSTLZ;
    }

    public String getSTRAS() {
        return STRAS;
    }

    public String getLOCAT() {
        return LOCAT;
    }

    public String getTELNR() {
        return TELNR;
    }

    public String getLIVE_TYPE() {
        return LIVE_TYPE;
    }

    public String getLIVE_TEXT() {
        return LIVE_TEXT;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public String getENDDA() {
        return ENDDA;
    }

    public String getANSSA() {
        return ANSSA;
    }

    public String getANSTX() {
        return ANSTX;
    }

    public String getADRES() {
        return ADRES;
    }

    public String getNAME2() {
        return NAME2;
    }

    public String getORT01() {
        return ORT01;
    }

    public String getORT02() {
        return ORT02;
    }

    public String getHSNMR() {
        return HSNMR;
    }

    public String getSTATE() {
        return STATE;
    }

    public String getBEZEI() {
        return BEZEI;
    }

    public String getPOSTA() {
        return POSTA;
    }

    public String getCOUNC() {
        return COUNC;
    }

    public String getBEZEI1() {
        return BEZEI1;
    }

    public String getADRTW() {
        return ADRTW;
    }

    public String getVILLA() {
        return VILLA;
    }

    public String getNEIGH() {
        return NEIGH;
    }

    public String getBEZEI2() {
        return BEZEI2;
    }

    public String getTOWN() {
        return TOWN;
    }

    public String getOR2KK() {
        return OR2KK;
    }

    public String getENTKM() {
        return ENTKM;
    }

    public String getTERY0() {
        return TERY0;
    }

    public String getTERY1() {
        return TERY1;
    }

    public String getTERY2() {
        return TERY2;
    }

    public String getRCTVC() {
        return RCTVC;
    }

    public String getTTEXT() {
        return TTEXT;
    }

    public String getBLAND() {
        return BLAND;
    }

    public String getPERNR() {
        return PERNR;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public String getZPERNR() {
        return ZPERNR;
    }

    public String getAEDTM() {
        return AEDTM;
    }

    public String getUNAME() {
        return UNAME;
    }

    public String getCERT_FLAG() {
        return CERT_FLAG;
    }

    public String getCERT_DATE() {
        return CERT_DATE;
    }

    public String getZUNAME() {
        return ZUNAME;
    }

    public String getAddress() {
        return address;
    }

    public String getACOLOR() {
        return ACOLOR;
    }

    public void setACOLOR(String ACOLOR) {
        this.ACOLOR = ACOLOR;
    }
}
