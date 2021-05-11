package eng.shdr;

class Curve extends h3d.shader.ScreenShader {
    static var SRC = {
        @param var texture : Sampler2D;
        @param var resX : Int;
        @param var resY : Int;
        
        function fragment() {
            var screenScale = vec2(resX, resY);

            var BARREL_DISTORTION = vec2(0.1, 0.25);
            // Barrel distortion shrinks the display area a bit, this will allow us to counteract that.
            var barrelScale = vec2(1.0 - 0.23 * BARREL_DISTORTION);


            var coord = input.uv * screenScale;
            coord -= vec2(0.5);
            var rsq = coord.x * coord.x + coord.y * coord.y;
            coord += coord * (BARREL_DISTORTION * rsq);
            coord *= barrelScale;
            if (abs(coord.x) >= 0.5 || abs(coord.y) >= 0.5)
                coord = vec2(-1.0);     // If out of bounds, return an invalid value.
            else
            {
                coord += vec2(0.5);
                coord /= screenScale;
            }

            if (coord.x < 0.0) {
                pixelColor = vec4(0.0);
            }
            else
            {
               var colour = texture.get(coord).rgb;
               pixelColor = vec4(colour,1.0);
            }

        }
    }
}