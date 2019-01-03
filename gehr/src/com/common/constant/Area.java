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
    *  [CSR ID:3440690] 베트남법인 GEHR 적용 요청
    *  OT("99") 추가
    *  [CSR ID:3516631] 태국 법인 Roll in 에 따른 Globlal HR Portal 적용 요청건
    *  TH("26") 추가
    *  @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel 
    *  MX("32") 추가
    *   */

    private String molga;

    Area(String molga) {
        this.molga = molga;
    }

    public String getMolga() {
        return molga;
    }

    /**
     * molga 코드에 해당하는 Area enum값을 리턴
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
