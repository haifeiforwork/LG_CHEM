(function($) {
if (typeof $ === 'function') {

$.extend(String, {
    /**
     * 글자수 반환
     */
    getLength: function(t) {
        return (typeof t === 'undefined' || t === null) ? 0 : String(t).length;
    },
    /**
     * byte length 반환
     * 
     * @param b, i, c 변수 선언 코딩량을 줄이기 위한 parameter
     */
    getByteLength: function(t, b, i, c) {
        t = (typeof t === 'undefined' || t === null) ? '' : String(t);
        for (b = i = 0; c = t.charCodeAt(i++); b += c >> 11 ? 3 : c >> 7 ? 2 : 1);
        return b;
    },
    /**
     * @param t target
     * @param c character
     */
    trim: function(t, c) {
        return (typeof t === 'undefined' || t === null) ? '' : String(t).replace(c ? new RegExp('^' + c + '+\|' + c + '+$', 'g') : /^\s+|\s+$/g, '');
    },
    /**
     * @param t target
     * @param c character
     */
    ltrim: function(t, c) {
        return (typeof t === 'undefined' || t === null) ? '' : String(t).replace(c ? new RegExp('^' + c + '+') : /^\s+/, '');
    },
    /**
     * @param t target
     * @param c character
     */
    rtrim: function(t, c) {
        return (typeof t === 'undefined' || t === null) ? '' : String(t).replace(c ? new RegExp(c + '+$') : /\s+$/, '');
    },
    /**
     * @param t target
     * @param l length
     * @param c character
     * @param b force
     */
    lpad: function(t, l, c, b) {
        t = (typeof t === 'undefined' || t === null) ? '' : String(t);
        return (b || t) ? (t.length >= l ? t.substr(0, l) : String.lpad(c + t, l, c, b)) : '';
    },
    /**
     * @param t target
     * @param l length
     * @param c character
     * @param b force
     */
    rpad: function(t, l, c, b) {
        t = (typeof t === 'undefined' || t === null) ? '' : String(t);
        return (b || t) ? (t.length >= l ? t.slice(-l) : String.rpad(t + c, l, c, b)) : '';
    },
    /**
     * null to default
     * 
     * @param t target
     * @param d default value
     */
    defaultIfBlank: function(t, d) {
        t = $.trim(t);
        return t ? t : (d || '');
    },
    /**
     * 좌우 반전
     */
    reverse: function(t) {
        return (t || '').split('').reverse().join('');
    },
    /**
     * 모든 Hyphen 제거
     */
    unhyphenate: function(t) {
        return String(t || '').replace(/-/g, '');
    },
    /**
     * @param t target, t가 문자열인 경우에만 + 표시를 살릴 수 있음
     * @param x Optional. The number of digits after the decimal point. Default is 0 (no digits after the decimal point)
     */
    toFixed: function(t, x) {
        if (!$.isNumeric(t)) throw new Error('대상이 숫자가 아닙니다.\n\n입력 : ' + t);
        if (x && !$.isNumeric(x)) throw new Error('소수자리수가 숫자가 아닙니다.\n\n입력 : ' + x);
        return $.trim(t).replace(/(^\+?).*/, '$1') + Number(t).toFixed(x);
    },
    /**
     * Comma 추가
     * 
     * ex) String.comma( '001234567890.1234')       =>  1,234,567,890.1234
     *     String.comma( '001234567890.1234', true) => +1,234,567,890.1234
     *     String.comma('+001234567890.1234')       =>  1,234,567,890.1234
     *     String.comma('+001234567890.1234', true) => +1,234,567,890.1234
     *     String.comma('-001234567890.1234')       => -1,234,567,890.1234
     *     String.comma('-001234567890.1234', true) => -1,234,567,890.1234
     */
    comma: function(t, b) {
        var r = String.parseNumeric(t, b).split('.');
        r[0] = r[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        return r[1] ? r.join('.') : r[0];
    },
    /**
     * Comma 제거
     * 
     * ex) String.comma( '001,234,567,890.1234')       =>  1234567890.1234
     *     String.comma( '001,234,567,890.1234', true) => +1234567890.1234
     *     String.comma('+001,234,567,890.1234')       =>  1234567890.1234
     *     String.comma('+001,234,567,890.1234', true) => +1234567890.1234
     *     String.comma('-001,234,567,890.1234')       => -1234567890.1234
     *     String.comma('-001,234,567,890.1234', true) => -1234567890.1234
     */
    uncomma: function(t, b) {
        return String.parseNumeric(t, b).replace(/,/g, '');
    },
    /**
     * 숫자에서 +- 부호 강제 제거, 이익률 계산시 사용됨
     */
    unsign: function(t) {
        return String.parseNumeric(t).replace(/^[+-]/g, '');
    },
    /**
     * 문자열에서 숫자형(부호, 숫자, 소수점) 문자만 parsing
     * 
     * 부호   : 첫번째 문자가 부호인 경우에만 남기고 나머지 부호 모두 제거
     * 소수점 : 첫번째 매치되는 소수점만 남기고 나머지 소수점 모두 제거
     * 
     * @param t parsing 대상 문자열
     * @param b '+' 부호 parsing 여부, true인 경우 대상 문자열에 '+'가 없어도 붙여서 return
     * @return parsing된 문자열
     * 
     * ex) String.parseNumeric(  '0-+0012f .. 3g4h5>.<6h   7h8+j9-j0')       =>  12.34567890
     *     String.parseNumeric(  '0-+0012f .. 3g4h5>.<6h   7h8+j9-j0', true) => +12.34567890
     *     String.parseNumeric('+-0-+0012f .. 3g4h5>.<6h   7h8+j9-j0')       =>  12.34567890
     *     String.parseNumeric('+-0-+0012f .. 3g4h5>.<6h   7h8+j9-j0', true) => +12.34567890
     *     String.parseNumeric('-+0-+0012f .. 3g4h5>.<6h   7h8+j9-j0')       => -12.34567890
     *     String.parseNumeric('-+0-+0012f .. 3g4h5>.<6h   7h8+j9-j0', true) => -12.34567890
     */
    parseNumeric: function(t, b) {
        t = ($.trim(t) || '0')
            .replace(/(^[+-]?)|[+-]/g, '$1')       // 첫번째 문자가 부호인 경우에만 남기고 나머지 부호 모두 제거 
            .replace(/(^[^.]*\.)|\./g, '$1')       // 첫번째 매치되는 소수점만 남기고 나머지 소수점 모두 제거
            .replace(/[^+-.\d]/g, '')              // 부호, 소수점, 숫자 외의 문자 모두 제거
            .replace(/^([+-.]*)0+(?!\.|$)/, '$1'); // 불필요한 leading zero 문자 모두 제거
        var nt = Number(t);
        return nt === 0 ? t.replace(/[+-]/, '') : (b ? (nt > 0 && !/^\+/.test(t) ? '+' + t : t) : t.replace(/^\+/, '')); // 0.00 인 경우를 대비해서 0을 바로 return 하면 안됨
    }
});
$.extend(String.prototype, {
    /**
     * 글자수 반환
     */
    getLength: function() {
        return String.getLength(this);
    },
    /**
     * byte length 반환
     */
    getByteLength: function() {
        return String.getByteLength(this);
    },
    /**
     * @param c character
     */
    trim: function(c) {
        return String.trim(this, c);
    },
    /**
     * @param c character
     */
    ltrim: function(c) {
        return String.ltrim(this, c);
    },
    /**
     * @param c character
     */
    rtrim: function(c) {
        return String.rtrim(this, c);
    },
    /**
     * @param l length
     * @param c character
     * @param b force
     */
    lpad: function(l, c, b) {
        return String.lpad(this, l, c, b);
    },
    /**
     * @param l length
     * @param c character
     * @param b force
     */
    rpad: function(l, c, b) {
        return String.lpad(this, l, c, b);
    },
    /**
     * null to default
     * 
     * @param d default value
     */
    defaultIfBlank: function(d) {
        return String.defaultIfBlank(this, d);
    },
    reverse: function() {
        return String.reverse(this);
    },
    /**
     * Hyphen 제거
     */
    unhyphenate: function() {
        return String.unhyphenate(this);
    },
    /**
     * @param t target
     * @param x Optional. The number of digits after the decimal point. Default is 0 (no digits after the decimal point)
     */
    toFixed: function(x) {
        return String.toFixed(this, x);
    },
    /**
     * Comma 추가
     */
    comma: function(b) {
        return String.comma(this, b);
    },
    /**
     * Comma 제거
     */
    uncomma: function(b) {
        return String.uncomma(this, b);
    },
    /**
     * 숫자에서 +- 부호 강제 제거, 이익율 계산시 사용됨
     */
    unsign: function() {
        return String.unsign(this);
    },
    /**
     * 문자열에서 숫자형 문자만 parsing
     * 숫자형 문자는 부호(최초에 매치되는 부호만 남김), 숫자, 소수점(최초에 매치되는 소수점만 남김)
     * 
     * @param b 부호 parsing 여부, (-) 부호는 무조건 parsing 됨
     * @return parsing된 문자열
     */
    parseNumeric: function(b) {
        return String.parseNumeric(this, b);
    }
});

}
})(jQuery)