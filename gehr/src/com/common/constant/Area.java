package com.common.constant;

import org.apache.commons.lang.StringUtils;

/**
 * Created by manyjung on 2016-07-22.
 */
public enum Area {
    KR("41"), CN("28"), HK("27"), TW("42"), DE("01"), PL("46"), US("10"), TH("26"), OT("99"), MX("32"), NONE("");

    /*  KR : 41
    *  CN : 28
    *  HK : 27
    *  TW : 42
    *  DE : 01
    *  PL : 46
    *  US : 10
    *  [CSR ID:3440690] ��Ʈ������ GEHR ���� ��û
    *  OT("99") �߰�
    *  [CSR ID:3516631] �±� ���� Roll in �� ���� Globlal HR Portal ���� ��û��
    *  TH("26") �߰�
    *  @PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel 
    *  MX("32") �߰�
    *   */

    private String molga;

    Area(String molga) {
        this.molga = molga;
    }

    public String getMolga() {
        return molga;
    }

    /**
     * molga �ڵ忡 �ش��ϴ� Area enum���� ����
     * @param molga
     * @return
     */
    public static Area fromMolga(String molga) {
        for(Area area : Area.values()) {
            if(StringUtils.equals(area.getMolga(), molga)) return area;
        }
        return Area.NONE;
    }

}
