
void main()
{
    vec4 c = SKDefaultShading();
    c.rgb *= 1.0 - step(0.0, v_path_distance / u_path_length - u_progress);
    //c.a = step(1.0 - v_path_distance / u_path_length, a_inv_progress);
    //c.r = 1.0;//v_path_distance / u_path_length;
    //c.g = c.b = p;//0.0;
    //c.a = 1.0 - step(0.0, v_path_distance / u_path_length - p);
    //c.a = 1.0 - step(0.0, v_path_distance / u_path_length - 0.3);
    //c.r *= c.a;
    gl_FragColor = c;
}
