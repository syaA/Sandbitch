
void main()
{
    vec4 c = SKDefaultShading();
    c.rgb *= 1.0 - step(0.0, v_path_distance / u_path_length - u_progress);
    gl_FragColor = c;
}
