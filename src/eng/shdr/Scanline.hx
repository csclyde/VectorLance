package eng.shdr;

class Scanline extends h3d.shader.ScreenShader {
    static var SRC = {
        @param var texture : Sampler2D;
        @param var resX : Int;
        @param var resY : Int;
        
        function fragment() {
            var res = vec2(resX, resY);
            var q = input.position.xy / res.xy;
            
            var scans = clamp(0.05 + 1.85 * sin(3.5 * 1 + input.uv.y * resY * 20.0), 0.0, 1.0);
            var s = pow(scans, 1.7);
            
            var color = texture.get(input.uv);
            color = color * vec4(0.7 + 0.3 * s);
            //color *= 1.0 - 0.65 * vec4(clamp((mod(texture.get(input.uv).x, 2.0)-1.0)*2.0,0.0,1.0));

            pixelColor = color;
        }
    }
}