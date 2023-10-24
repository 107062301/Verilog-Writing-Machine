#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include<math.h>
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include "textfile.h"
#define STB_IMAGE_IMPLEMENTATION
#include <STB/stb_image.h>
#define M_PI 3.1415926535897932384626433832795

#define TINYOBJLOADER_IMPLEMENTATION
#include "tiny_obj_loader.h"

#define GLM_FORCE_SWIZZLE // Or defined when building (e.g. -DGLM_FORCE_SWIZZLE)
#include <glm/glm.hpp>
#include <glm/gtx/quaternion.hpp>
#include "glm/gtc/type_ptr.hpp"

#ifndef max
# define max(a,b) (((a)>(b))?(a):(b))
# define min(a,b) (((a)<(b))?(a):(b))
#endif

#define deg2rad(x) ((x)*((3.1415926f)/(180.0f)))

using namespace glm;
using namespace std;

// Default window size
const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 1000;
// current window size
int screenWidth = WINDOW_WIDTH, screenHeight = WINDOW_HEIGHT;

vector<string> filenames; // .obj filename list

typedef struct
{
	GLuint diffuseTexture;
} PhongMaterial;

typedef struct
{
	GLuint vao; //vao 指定 vbo讀取位置
	GLuint vbo;
	GLuint vboTex;
	GLuint ebo;
	GLuint p_color;
	int vertex_count;
	GLuint p_normal;
	GLuint p_texCoord;
	PhongMaterial material;
	int indexCount;
} Shape;

struct model
{
	vec3 position = vec3(0, 0, 0);
	vec3 scale = vec3(1, 1, 1);
	vec3 rotation = vec3(0, 0, 0);	// Euler form

	vector<Shape> shapes;
};
vector<model> models;

//model tl_h, bl_h, tr_h, br_h, tl_l, bl_l, tr_l, br_l, Torso, Head;

struct camera
{
	vec3 position;
	vec3 center;
	vec3 up_vector;
};
camera main_camera;

struct project_setting
{
	GLfloat nearClip, farClip;
	GLfloat fovy;
	GLfloat aspect;
};
project_setting proj;

Shape m_shpae;
// vector<Shape> m_shape_list;

int cur_idx = 0, cur_idx2 = 1; // represent which model should be rendered now
vector<string> model_list{ "../TextureModels/Cube.obj","../TextureModels/Capsule.obj","../TextureModels/Cylinder.obj", "../TextureModels/Sphere.obj","../TextureModels/c.obj","../TextureModels/d.obj","../TextureModels/e.obj","../TextureModels/f.obj","../TextureModels/b.obj","../TextureModels/Mew.obj","../TextureModels/Nyarth.obj","../TextureModels/Zenigame.obj", "../TextureModels/texturedknot.obj", "../TextureModels/laurana500.obj", "../TextureModels/Nala.obj" };

GLuint program;

GLuint iLocP;
GLuint iLocV;
GLuint iLocM;

GLfloat X_degree = 0.0, Y_degree = 0.0, Z_degree = 0.0,OLD;
vec3 rax = vec3(1.0, 0.0, 0.0), ray = vec3(0.0, 1.0, 0.0), raz = vec3(0.0, 0.0, 1.0);
vec3 vecY = vec3(0.0, 1.0, 0.0), vecX = vec3(1.0, 0.0, 0.0), vecZ = vec3(0.0, 0.0, 1.0);
mat4 controll_X = rotate(mat4(1.0), X_degree, rax);
mat4 controll_Y = rotate(mat4(1.0), Y_degree, ray);
mat4 controll_Z = rotate(mat4(1.0), Z_degree, raz);

float v, b, n;
vec3 t_left_hand = vec3(-2.2, 1.7, 0.0), b_left_hand = vec3(-2.2, 0.3, 0.0);
vec3 t_left_leg = vec3(-0.8, 0.0, 0.0), b_left_leg = vec3(-0.8, -1.7, 0.0);
vec3 t_right_hand = vec3(2.2, 1.7, 0.0), b_right_hand = vec3(2.2, 0.3, 0.0);
vec3 t_right_leg = vec3(0.8, 0.0, 0.0), b_right_leg = vec3(0.8, -1.7, 0.0);
vec3 torso = vec3(0.0, 2.0, 0.0), head = vec3(0.0, 3.7, 0.0);
vec3 kt_left_hand = vec3(-2.2, 2.8, 0.0), kb_left_hand = vec3(-2.2, 0.9, 0.0);
vec3 kt_left_leg = vec3(-0.8, 0.0, 0.0), kb_left_leg = vec3(-0.8, -1.7, 0.0);
vec3 kt_right_hand = vec3(2.2, 2.8, 0.0), kb_right_hand = vec3(2.2, 0.9, 0.0);
vec3 kt_right_leg = vec3(0.8, 0.0, 0.0), kb_right_leg = vec3(0.8, -1.7, 0.0);
vec3 ktorso = vec3(0.0, 2.0, 0.0);
vec3 origin = vec3(0, 0, 0);
bool ro,wa,ju,up,up2,look,look2,look3,Left,Right,Forward,Backward,drag_mode,drag_down = false, Roll,Rollback;
double curx, cury , delta_y = 0, drag_x,drag_y;
bool M_down = false;
string state1,state2;
mat4 tl_h, bl_h, tr_h, br_h, tl_l, bl_l, tr_l, br_l, Torso, Head, TEST;
GLfloat tr_de, br_de, tl_de, bl_de, trl_de, brl_de, tll_de, bll_de,torso_de,head_de;
vec3 tlh_axis, trh_axis, blh_axis, brh_axis, tll_axis, trl_axis, bll_axis, brl_axis, torso_axis, head_axis;
int clock,clock2,clock3,clock_x,clock_y,clock_z;
void init() {
	clock = clock2 = clock3 = clock_x = clock_y = clock_z = 0;
	Rollback = Roll = drag_mode = Forward = Backward = Left = Right = wa = ju = false;
	state1 = "down";
	state2 = "left";
	up = ro = true;
	head_de = torso_de = tr_de = br_de = tl_de = bl_de = trl_de = brl_de = tll_de = bll_de = 0.0;
	head_axis = torso_axis = tlh_axis = trh_axis = blh_axis = brh_axis = tll_axis = trl_axis = bll_axis = brl_axis = vec3(0.0, -0.5, 1.0);
}
void wave_hand() {
	if (wa) {
		if (state2 == "left") {
			tll_axis = bll_axis = vec3(1, 0, 0);
			trl_axis = brl_axis = vec3(1, 0, 0);
			tlh_axis = blh_axis = vec3(1, 0, 0);
			trh_axis = brh_axis = vec3(1, 0, 0);
			//torso_axis = vec3(cos(Y_degree*180/3.14), 0, sin(Y_degree*180/3.14));
			//cout << cos(Y_degree * 180 / 3.14) << " ," << sin(Y_degree * 180 / 3.14) << "\n";
			//torso_axis = vec3(0, cos(X_degree), -sin(X_degree));
			torso_axis = vec3(cos(Y_degree), 0, -sin(Y_degree));
			trl_de = clock / 250.0;
			brl_de = clock / 200.0;
			tll_de = -clock / 250.0;
			bll_de = clock / 200.0;
			tr_de = -clock / 250.0;
			br_de = -clock / 150.0;
			tl_de = clock / 250.0;
			bl_de = -clock / 150.0;
			torso_de = clock / 1000.0;
			if (clock >= 350) {
				state2 = "back";
			}
			else {
				clock++;
			}
		}
		else if (state2 == "back") {
			tll_axis = bll_axis = vec3(1, 0, 0);
			trl_axis = brl_axis = vec3(1, 0, 0);
			tlh_axis = blh_axis = vec3(1, 0, 0);
			trh_axis = brh_axis = vec3(1, 0, 0);
			//torso_axis = vec3(cos(Y_degree*180/3.14), 0, sin(Y_degree*180/3.14));
			//torso_axis = vec3(0, cos(X_degree), -sin(X_degree));
			torso_axis = vec3(cos(Y_degree), 0, -sin(Y_degree));
			//torso_axis = vec3(0, 0, 1);
			//torso_axis = vec3(1, 0, 0);
			trl_de = clock / 250.0;
			brl_de = clock / 200.0;
			tll_de = -clock / 250.0;
			bll_de = clock / 200.0;
			tr_de = -clock / 250.0;
			br_de = -clock / 150.0;
			tl_de = clock / 250.0;
			bl_de = -clock / 150.0;
			torso_de = clock / 1000.0;
			//torso_de = clock / 4000.0;
			if (clock >= 0) {
				clock--;
			}
			else {
				state2 = "right";
				clock = 0;
			}
		}
		else if (state2 == "right") {
			tll_axis = bll_axis = vec3(1, 0, 0);
			trl_axis = brl_axis = vec3(1, 0, 0);
			tlh_axis = blh_axis = vec3(1, 0, 0);
			trh_axis = brh_axis = vec3(1, 0, 0);
			//torso_axis = vec3(cos(Y_degree*180/3.14), 0, sin(Y_degree*180/3.14));
			//torso_axis = vec3(0, cos(X_degree), -sin(X_degree));
			torso_axis = vec3(cos(Y_degree), 0, -sin(Y_degree));
			//torso_axis = vec3(0, 0, 1);
			//torso_axis = vec3(1, 0, 0);
			trl_de = clock / 250.0;
			brl_de = -clock / 200.0;
			tll_de = -clock / 250.0;
			bll_de = -clock / 200.0;
			tr_de = -clock / 250.0;
			br_de = clock / 150.0;
			tl_de = clock / 250.0;
			bl_de = clock / 150.0;
			torso_de = -clock / 1000.0;
			//torso_de = clock / 4000.0;
			if (clock >= -350) {
				clock--;
			}
			else {
				state2 = "back2";
			}
		}
		else if (state2 == "back2") {
			//cout << "J";
			tll_axis = bll_axis = vec3(1, 0, 0);
			trl_axis = brl_axis = vec3(1, 0, 0);
			tlh_axis = blh_axis = vec3(1, 0, 0);
			trh_axis = brh_axis = vec3(1, 0, 0);
			//torso_axis = vec3(cos(Y_degree*180/3.14), 0, sin(Y_degree*180/3.14));
			//torso_axis = vec3(0, cos(X_degree), -sin(X_degree));
			torso_axis = vec3(cos(Y_degree), 0, -sin(Y_degree));
			//torso_axis = vec3(0, 0, 1);
			//torso_axis = vec3(1, 0, 0);
			trl_de = clock / 250.0;
			brl_de = -clock / 200.0;
			tll_de = -clock / 250.0;
			bll_de = -clock / 200.0;
			tr_de = -clock / 250.0;
			br_de = clock / 150.0;
			tl_de = clock / 250.0;
			bl_de = clock / 150.0;
			torso_de = -clock / 1000.0;
			if (clock < 0) {
				clock++;
			}
			else {
				state2 = "left";
				clock = 0;
			}
		}
	}
}

void jump() {
	if (ju) {
		if (state1=="down") {
			tll_axis = bll_axis = vec3(1, 0.5, 0.5);
			trl_axis = brl_axis = vec3(1, -0.5, -0.5);
			tlh_axis = blh_axis = vec3(-3, -3, 1);
			trh_axis = brh_axis = vec3(-3, 3, -1);
			torso_axis = vec3(cos(Y_degree), 0, -sin(Y_degree));
			torso.y -= 0.001;
			delta_y -= 0.001;
			clock2++;
			trl_de = -clock2 / 1000.0;
			brl_de = clock2 / 800.0;
			tll_de = -clock2 / 1000.0;
			bll_de = clock2 / 800.0;
			tr_de = -clock2 / 1000.0;
			br_de = clock2 / 600.0;
			tl_de = -clock2 / 1000.0;
			bl_de = clock2 / 600.0;
			torso_de = clock2 / 4000.0;
			if (clock2 >= 1300) {
				state1 = "up";
				//cout << torso_de;
			}
		}
		else if(state1 == "up"){
			tll_axis = bll_axis = vec3(1, 0.5, 0.5);
			trl_axis = brl_axis = vec3(1, -0.5, -0.5);
			tlh_axis = blh_axis = vec3(-3, -3, 1);
			trh_axis = brh_axis = vec3(-3, 3, -1);
			torso_axis = vec3(cos(Y_degree), 0, -sin(Y_degree));
			torso.y += 0.003;
			delta_y += 0.003;
			clock2 /= 1.005;
			trl_de = -clock2 / 1000.0/1.005;
			brl_de = clock2 / 800.0/1.005;
			tll_de = -clock2 / 1000.0/1.005;
			bll_de = clock2 / 800.0/1.005;
			tr_de = -clock2 / 1000.0 / 1.005;
			br_de = clock2 / 600.0 / 1.005;
			tl_de = -clock2 / 1000.0 / 1.005;
			bl_de = clock2 / 600.0 / 1.005;
			torso_de = clock2 / 4000.0 /1.005;
			if (clock2 > 0) {
				clock3 = clock2;
				clock2--;
			}
			else {
				state1 = "jump";
				clock3 = clock2;
				clock2 = 0;
			}
		}
		else if(state1 == "jump"){
			tlh_axis = blh_axis = vec3(3, 0, 1);
			trh_axis = brh_axis = vec3(3, 0, -1);
			if (clock2 <= 500) {
				clock2 += 1;
			}
			else{
				//cout << t_left_hand.y;
				state1 = "land";
				clock2 *= 2;
			}
			torso.y += 0.005;
			delta_y += 0.005;
			//clock2 /= 4;
			tr_de = -clock2 / 250.0;
			br_de = -clock2 / 200.0;
			tl_de = -clock2 / 250.0;
			bl_de = -clock2 / 200.0;
		}
		else if (state1 == "land") {
			if (clock2 >= 644) {
				clock2 -= 1;
			}
			else {
				state1 = "recover";
			}
			tlh_axis = blh_axis = vec3(3, 0, 1);
			trh_axis = brh_axis = vec3(3, 0, -1);
			torso.y -= 0.006;
			delta_y -= 0.006;
			tr_de = -clock2 / 500.0;
			br_de = -clock2 / 400.0;
			tl_de = -clock2 / 500.0;
			bl_de = -clock2 / 400.0;
		}
		else if (state1 == "recover") {
			if (clock2 >= 0) {
				clock2 -= 1;
				clock3 -= 1;
			}
			else {
				state1 = "down";
				clock2 = 0;
			}
			delta_y = 0;
			clock3 /= 1.005;
			tll_axis = bll_axis = vec3(1, 0.5, 0.5);
			trl_axis = brl_axis = vec3(1, -0.5, -0.5);
			torso_axis = vec3(cos(Y_degree), 0, -sin(Y_degree));
			trl_de = -clock3 / 1000.0 / 1.005;
			brl_de = clock3 / 800.0 / 1.005;
			tll_de = -clock3 / 1000.0 / 1.005;
			bll_de = clock3 / 800.0 / 1.005;
			tlh_axis = blh_axis = vec3(3, 0, 1);
			trh_axis = brh_axis = vec3(3, 0, -1);
			tr_de = -clock2 / 500.0;
			br_de = -clock2 / 400.0;
			tl_de = -clock2 / 500.0;
			bl_de = -clock2 / 400.0;
		}
	}
}

// Call back function for window reshape
void ChangeSize(GLFWwindow* window, int width, int height)
{
	// glViewport(0, 0, width, height);
	proj.aspect = (float)(width) / (float)height;
	screenWidth = width;
	screenHeight = height;
	glViewport(0, 0, screenWidth, screenHeight);
}

void create_body(mat4 model1, int cur_id, vec3 pos, vec3 scale,string str) {
	mat4 project_matrix;
	project_matrix = perspective(deg2rad(proj.fovy), proj.aspect, proj.nearClip, proj.farClip);

	mat4 view_matrix;
	view_matrix = lookAt(main_camera.position, main_camera.center, main_camera.up_vector);

	mat4 T, R, T2, T3, S;
	
	models[cur_id].position = pos;
	S = glm::scale(mat4(1.0), scale);
	T = translate(mat4(1.0), pos);
	T2 = translate(mat4(1.0), vec3(0, 1.0, 0.0));
	T3 = translate(mat4(1.0), vec3(0, -1.0, 0.0)); //translate的比例 0.5 = x方向寬度的0.5倍
	GLfloat degree = glfwGetTime() / 2.0;
	//vec3 rotate_axis = vec3(0.0, -1.0, 1.0);
	
	mat4 model_matrix = T*S;
	if (ro && str == "r") {
		mat4 Adjust = translate(mat4(1.0), vec3(2.2, 0.4, 0.0));
		R = rotate(mat4(1.0), tr_de, trh_axis);
		model_matrix = Torso * Adjust * T2 * R * S * T3;
		tr_h = Torso * Adjust * T2 * R * T3;
	}
	else if (ro && str == "rr") {
		mat4 Adjust = translate(mat4(1.0), vec3(0.0, -1.8, 0.0));
		mat4 r2 = rotate(mat4(1.0), br_de, brh_axis);
		model_matrix = tr_h * Adjust  * T2 * r2 * S * T3;
	}
	else if (ro && (str == "krh1" || str == "krh2")) {
		mat4 Adjust;
		if (str == "krh1") {
			Adjust = translate(mat4(1.0), vec3(2.2, 1.7, 0.0));
			GLfloat k = M_PI;
			mat4 rr = rotate(mat4(1.0), k , vec3(0,1,0));
			model_matrix = Torso * Adjust * S * rr;
		}
		else {
			Adjust = translate(mat4(1.0), vec3(0.0, -0.6, 0.0));
			model_matrix = tr_h * Adjust * S;
		}
	}
	else if (ro && (str == "klh1" || str == "klh2")) {
		mat4 Adjust;
		if (str == "klh1") {
			Adjust = translate(mat4(1.0), vec3(-2.2, 1.7, 0.0));
			model_matrix = Torso * Adjust * S;
		}
		else {
			Adjust = translate(mat4(1.0), vec3(0.0, -0.6, 0.0));
			model_matrix = tl_h * Adjust * S;
		}
	}
	else if (ro && (str == "kbr1" || str == "kbr2")) {
		mat4 Adjust;
		if (str == "kbr1") {
			Adjust = translate(mat4(1.0), vec3(0.8, -1.1, 0.0));
			model_matrix = Torso * Adjust * S;
		}
		else {
			Adjust = translate(mat4(1.0), vec3(0.0, -0.6, 0.0));
			model_matrix = tr_l * Adjust * S;
		}
	}
	else if (ro && (str == "kbl1" || str == "kbl2")) {
		mat4 Adjust;
		if (str == "kbl1") {
			Adjust = translate(mat4(1.0), vec3(-0.8, -1.1, 0.0));
			model_matrix = Torso * Adjust * S;
		}
		else {
			Adjust = translate(mat4(1.0), vec3(0.0, -0.6, 0.0));
			model_matrix = tl_l * Adjust * S;
		}
	}
	else if (ro && str == "l") {
		mat4 Adjust = translate(mat4(1.0), vec3(-2.2, 0.4, 0.0));
		R = rotate(mat4(1.0), tl_de, tlh_axis);
		model_matrix = Torso * Adjust * T2 * R * S * T3;
		tl_h = Torso * Adjust * T2 * R * T3;
	}
	else if (ro && str == "ll") {
		mat4 Adjust = translate(mat4(1.0), vec3(0.0, -1.8, 0.0));
		mat4 r2 = rotate(mat4(1.0), bl_de, blh_axis);
		model_matrix = tl_h * Adjust * T2 * r2 * S * T3;
	}
	else if(ro && str == "br") {
		mat4 Adjust = translate(mat4(1.0), vec3(0.8, -2.3, 0.0));
		R = rotate(mat4(1.0), trl_de, trl_axis);
		model_matrix = Torso * Adjust * T2 * R * S * T3;
		tr_l = Torso * Adjust * T2 * R * T3;
	}
	else if (ro && str == "brr") {
		mat4 Adjust = translate(mat4(1.0), vec3(0.0, -1.8, 0.0));
		mat4 r2 = rotate(mat4(1.0), brl_de, brl_axis);
		model_matrix = tr_l * Adjust * T2 * r2 * S * T3;
	}
	else if (ro && str == "bl") {
		mat4 Adjust = translate(mat4(1.0), vec3(-0.8, -2.3, 0.0));
		R = rotate(mat4(1.0), tll_de, tll_axis);
		model_matrix = Torso * Adjust * T2 * R * S * T3;
		tl_l = Torso * Adjust * T2 * R * T3;
	}
	else if (ro && str == "bll") {
		mat4 Adjust = translate(mat4(1.0), vec3(0.0, -1.8, 0.0));
		mat4 r2 = rotate(mat4(1.0), bll_de, bll_axis);
		model_matrix = tl_l * Adjust * T2 * r2 * S * T3;
	}
	else if (ro && str == "t") {
		mat4 r2 = rotate(mat4(1.0), torso_de, torso_axis);
		mat4 r3,temp;
		quat Myq;

		r3 = r2 * controll_X * controll_Y * controll_Z;     //*controll_X* controll_Y* controll_Z
		T2 = translate(mat4(1.0), vec3(0, -1.0, 0.0));
		T3 = translate(mat4(1.0), vec3(0, 1.0, 0.0));
		model_matrix = T * T2 * r3 * S * T3;
		Torso = T * T2 * r3 * T3;
	}
	else if (ro && str == "h") {
		mat4 Adjust = translate(mat4(1.0), vec3(0.0, 2.7, 0.0));
		mat4 r2 = rotate(mat4(1.0), head_de, head_axis);
		model_matrix = Torso * Adjust * r2 * S;
		Head = Torso * Adjust * r2;
	}
	else if (ro && str == "kt" ) {
		mat4 Adjust = translate(mat4(1.0), vec3(0.0, 2.1, 0.0));
		model_matrix = Torso * Adjust * S;
	}
	
	glUniformMatrix4fv(iLocM, 1, GL_FALSE, value_ptr(model_matrix));
	glUniformMatrix4fv(iLocV, 1, GL_FALSE, value_ptr(view_matrix));
	glUniformMatrix4fv(iLocP, 1, GL_FALSE, value_ptr(project_matrix));


	for (int i = 0; i < models[cur_id].shapes.size(); i++)
	{
		glBindVertexArray(models[cur_id].shapes[i].vao);
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, models[cur_id].shapes[i].material.diffuseTexture);
		glDrawArrays(GL_TRIANGLES, 0, models[cur_id].shapes[i].vertex_count);
	}
}
// Render function for display rendering

void create_body2(int cur_id, vec3 pos, vec3 scale, string str) {
	mat4 project_matrix;
	project_matrix = perspective(deg2rad(proj.fovy), proj.aspect, proj.nearClip, proj.farClip);

	mat4 view_matrix;
	view_matrix = lookAt(main_camera.position, main_camera.center, main_camera.up_vector);

	mat4 T, R, T2, T3, S;

	models[cur_id].position = pos;
	S = glm::scale(mat4(1.0), scale);
	T = translate(mat4(1.0), pos);
	T2 = translate(mat4(1.0), vec3(0, 1.0, 0.0));
	T3 = translate(mat4(1.0), vec3(0, -1.0, 0.0)); //translate的比例 0.5 = x方向寬度的0.5倍
	GLfloat degree = glfwGetTime() / 2.0;
	mat4 model_matrix;
	
	 if (str == "t") {
		mat4 r2 = rotate(mat4(1.0), torso_de, torso_axis);
		mat4 r3, temp;
		quat Myq;

		r3 = r2 * controll_X * controll_Y * controll_Z;     //*controll_X* controll_Y* controll_Z
	}
	else if (str == "to") {
		 mat4 Adjust = translate(mat4(1.0), pos);
		 model_matrix = Torso * Adjust * S;
	}
	else if (ro && str == "ha") {
		mat4 Adjust = translate(mat4(1.0), pos);		
		model_matrix = Head * Adjust * S;
	}
	else if (ro && str == "fl1") {
		 mat4 Adjust = translate(mat4(1.0), pos);
		 GLfloat kk = 0.5;
		 T2 = translate(mat4(1.0), vec3(0, 0.5, 0.0));
		 T3 = translate(mat4(1.0), vec3(0, -0.5, 0.0));
		 mat4 r2 = rotate(mat4(1.0), kk, vec3(1,1,0.8));
		 model_matrix = Torso * Adjust * T2 * r2 * T3 * S ;
	}
	else if (ro && str == "fl2") {
		 mat4 Adjust = translate(mat4(1.0), pos);
		 GLfloat kk = -0.5;
		 T2 = translate(mat4(1.0), vec3(0, -0.5, 0.0));
		 T3 = translate(mat4(1.0), vec3(0, 0.5, 0.0));
		 mat4 r2 = rotate(mat4(1.0), kk, vec3(-1, 1, 0.8));
		 model_matrix = Torso * Adjust * T2 * r2 * T3 * S;
	 }

	glUniformMatrix4fv(iLocM, 1, GL_FALSE, value_ptr(model_matrix));
	glUniformMatrix4fv(iLocV, 1, GL_FALSE, value_ptr(view_matrix));
	glUniformMatrix4fv(iLocP, 1, GL_FALSE, value_ptr(project_matrix));


	for (int i = 0; i < models[cur_id].shapes.size(); i++)
	{
		glBindVertexArray(models[cur_id].shapes[i].vao);
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, models[cur_id].shapes[i].material.diffuseTexture);
		glDrawArrays(GL_TRIANGLES, 0, models[cur_id].shapes[i].vertex_count);
	}
}
void RenderScene(int cur_id) {	
	// clear canvas
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
	mat4 T, R, T2;
	T = translate(mat4(1.0), models[cur_id].position);
	
	T2 = translate(mat4(1.0), models[cur_id].position);
	//Build rotation matrix
	//GLfloat degree = glfwGetTime() / 10.0;
	GLfloat degree = 0.0;
	vec3 rotate_axis = vec3(0.0, 1.0, 0.0);
	R = rotate(mat4(1.0), degree, rotate_axis) * controll_X * controll_Y * controll_Z;
	// * controll_X * controll_Y * controll_Z
	mat4 project_matrix;
	// perspective(fov, aspect_ratio, near_plane_distance, far_plane_distance)
	// ps. fov = field of view, it represent how much range(degree) is this camera could see 
	project_matrix = perspective(deg2rad(proj.fovy), proj.aspect, proj.nearClip, proj.farClip);

	mat4 view_matrix;
	// lookAt(camera_position, camera_viewing_vector, up_vector)
	// up_vector represent the vector which define the direction of 'up'
	view_matrix = lookAt(main_camera.position, main_camera.center, main_camera.up_vector);

	// render object
	mat4 tl_h, bl_h, tr_h, br_h, tl_l, bl_l, tr_l, br_l, Torso, Head;
	string n1="r", n2="o", n3 = "rr";
	
	vec3 tlh = vec3(1.0, 0.7, 1.0), blh = vec3(1.0, 0.7, 1.0);
	vec3 tll = vec3(1.0, 0.7, 1.0), bll = vec3(1.0, 0.7, 1.0);
	vec3 trh = vec3(1.0, 0.7, 1.0), brh = vec3(1.0, 0.7, 1.0);
	vec3 trl = vec3(1.0, 0.7, 1.0), brl = vec3(1.0, 0.7, 1.0);
	vec3 t = vec3(3.0, 1.5, 1.0), h = vec3(1.0, 0.5, 1.0),knockle = vec3(0.3,0.3,0.3),shoulder = vec3(0.7, 0.7, 0.7);
	mat4 model_matrix = mat4(1.0), model_matrix2 = mat4(1.0);

	create_body(model_matrix, 5, t_left_hand,tlh,"l");
	create_body(model_matrix2, 7, b_left_hand,blh,"ll");
	create_body(model_matrix, 6, t_left_leg,tll,"bl");
	create_body(model_matrix2, 7, b_left_leg,bll,"bll");
	create_body(model_matrix, 5, t_right_hand,trh,"r");
	create_body(model_matrix2, 7, b_right_hand,brh,"rr");
	create_body(model_matrix, 6, t_right_leg,trl,"br");
	create_body(model_matrix2, 7, b_right_leg,brl,"brr");
	create_body(model_matrix, 7, torso,t,"t");
	create_body(model_matrix2, 4, head,h,"h");
	create_body(model_matrix, 8, kt_left_hand, shoulder, "klh1");
	create_body(model_matrix2, 3, kb_left_hand, knockle, "klh2");
	create_body(model_matrix, 3, kt_left_leg, knockle, "kbl1");
	create_body(model_matrix2, 3, kb_left_leg, knockle, "kbl2");
	create_body(model_matrix, 8, kt_right_hand, shoulder, "krh1");
	create_body(model_matrix2, 3, kb_right_hand, knockle, "krh2");
	create_body(model_matrix, 3, kt_right_leg, knockle, "kbr1");
	create_body(model_matrix2, 3, kb_right_leg, knockle, "kbr2");
	create_body(model_matrix, 1, ktorso, shoulder, "kt");
	create_body2(0, vec3(-0.7,1.2,0.3),vec3(0.6,0.5,0.4),"to");
	create_body2(0, vec3(0.7, 1.2, 0.3), vec3(0.6, 0.5, 0.4), "to");
	create_body2(0, vec3(0.4, 0.3, 0.3), vec3(0.3, 0.2, 0.3), "to");
	create_body2(0, vec3(0.4, -0.15, 0.3), vec3(0.3, 0.2, 0.3), "to");
	create_body2(0, vec3(0.4, -0.6, 0.3), vec3(0.3, 0.2, 0.3), "to");
	create_body2(0, vec3(-0.4, 0.3, 0.3), vec3(0.3, 0.2, 0.3), "to");
	create_body2(0, vec3(-0.4, -0.15, 0.3), vec3(0.3, 0.2, 0.3), "to");
	create_body2(0, vec3(-0.4, -0.6, 0.3), vec3(0.3, 0.2, 0.3), "to");
	create_body2(0, vec3(2.4, 1.5, -1.3), vec3(2.4, 0.6, 0.1), "fl1");
	create_body2(0, vec3(-2.8, 1.6, -1.4), vec3(2.4, 0.6, 0.1), "fl2");
	create_body2(0, vec3(0.9, -0.1, -1.0), vec3(0.7, 0.3, 0.1), "fl1");
	create_body2(0, vec3(-1.2,0.0, -1.1), vec3(0.7, 0.3, 0.1), "fl2");
	create_body2(0, vec3(0, 0.6, 0), vec3(0.55, 0.2, 0.55), "ha");
	create_body2(0, vec3(0, 0, -0.42), vec3(0.5, 0.5, 0.1), "ha");
	create_body2(0, vec3(0, 0, 0.3), vec3(0.5, 0.5, 0.1), "ha");
	create_body2(0, vec3(0, 0.5, 0.6), vec3(0.52, 0.05, 0.3), "ha");
	//create_body(model_matrix, 2,n2);
}

// Call back function for keyboard
void KeyCallback(GLFWwindow* window, int key, int scancode, int action, int mods)
{	
	if (action == GLFW_PRESS) {
		switch (key)
		{
		case GLFW_KEY_D:
			printf("press d!\n");
			Right = true;
			break;
		case GLFW_KEY_A:
			printf("press a!\n");
			Left = true;
			break;
		case GLFW_KEY_W:
			printf("press w!\n");
			Forward = true;
			break;
		case GLFW_KEY_S:
			printf("press s!\n");
			Backward = true;
			break;
		case GLFW_KEY_R:
			printf("press R!\n");
			drag_mode = !drag_mode;
			//cout << "torso : " << torso.x << " , " << torso.y << "\n";
			break;
		case GLFW_KEY_L:
			ro = !ro;
			break;
		case GLFW_KEY_X:
			//printf("press x!\n");
			//X_degree += M_PI/18;
			/*if (!look2) {
				X_degree += clock_x / 1000;
			}*/
			look2 = !look2;
			//vec3 rotate_axis1 = vec3(1.0, 0.0, 0.0);
			/*torso_axis = vec3(1, 0, 0);
			torso_de += 3.14 / 18;
			/*vec3 EulerAngles2(10, 0, 0);
			vec3 rotated_point2;
			quat Myquat2;
			Myquat2 = quat(EulerAngles2);
			rotated_point2 = origin + (Myquat2 * (rotate_axis1 - origin));
			origin = rotated_point2;*/
			//controll_X = rotate(mat4(1.0), X_degree, rotate_axis1);
			break;
		case GLFW_KEY_Y:
			//printf("press x!\n");
			//Y_degree += M_PI /4;
			look = !look;
			//vec3 rotate_axis2 = vec3(0.0, 1.0, 0.0);
			/*torso_axis = vec3(0, 1, 0);
			torso_de += 3.14 / 18;
			/*vec3 EulerAngles(0, 10, 0);
			vec3 p = vec3(1, 2, 3), p2, rotated_point;
			quat Myquat;
			Myquat = quat(EulerAngles);
			rotated_point = origin + (Myquat* (rotate_axis2 - origin));
			origin = rotated_point;*/
			//controll_Y = rotate(mat4(1.0), Y_degree, rotate_axis2);
			break;
		case GLFW_KEY_Z:
			//printf("press x!\n");
			//Z_degree += M_PI /18;
			look3 = !look3;
			//vec3 rotate_axis3 = vec3(0.0, 0.0, 1.0);
			/*torso_axis = vec3(0, 0, 1);
			torso_de += 3.14 / 18;
			/*vec3 EulerAngles3(0, 0, 10);
			vec3 rotated_point3;
			quat Myquat3;
			Myquat3 = quat(EulerAngles3);
			rotated_point3 = origin + (Myquat3 * (rotate_axis3 - origin));
			origin = rotated_point3;*/
			//controll_Z = rotate(mat4(1.0), Z_degree, rotate_axis3);
			break;
		case GLFW_KEY_UP:
			//tr_de += 0.2;
			v += 0.05;
			break;
		case GLFW_KEY_DOWN:
			//tr_de -= 0.2;
			b += 0.05;
			break;
		case GLFW_KEY_LEFT:
			//br_de -= 0.2;
			n += 0.05;
			break;
		case GLFW_KEY_RIGHT:
			//br_de += 0.2;
			v -= 0.05;
			break;
		case GLFW_KEY_5:
			//tl_de += 0.2;
			b -= 0.05;
			break;
		case GLFW_KEY_3:
			bl_de += 0.2;
			break;
		case GLFW_KEY_F:
			wa = !wa;
			break;
		case GLFW_KEY_G:
			ju = !ju;
			break;
		case GLFW_KEY_1:
			Roll = !Roll;
			break;
		case GLFW_KEY_2:
			Rollback = !Rollback;
			break;
		default:
			break;
		}
	}
	if (action == GLFW_RELEASE) {
		switch (key)
		{
		case GLFW_KEY_D:
			printf("press d!\n");
			Right = false;
			break;
		case GLFW_KEY_A:
			printf("press a!\n");
			Left = false;
			break;
		case GLFW_KEY_W:
			printf("press w!\n");
			Forward = false;
			break;
		case GLFW_KEY_S:
			printf("press s!\n");
			Backward = false;
			break;
		default:
			break;
		}
	}
}
void _Rotate() {
	if (look) {
		Y_degree = clock_y / 1000.0;
		torso_axis = vec3(cos(Y_degree), 0, -sin(Y_degree));
		clock_y+=1;
		vecY = vec3(0, cos(X_degree), -sin(X_degree));
		controll_Y = rotate(mat4(1.0), Y_degree, vec3(0,1,0));
		//controll_Y = rotate(mat4(1.0), Y_degree, vec3(0,cos(X_degree),-sin(X_degree)));
		if (clock_y == 6340) clock_y = 0;
	}
	if (look2) {
		X_degree = clock_x / 1000.0;
		//torso_axis = vec3(0, cos(X_degree), -sin(X_degree));
		clock_x += 1;
		controll_X = rotate(mat4(1.0), X_degree, vec3(1, 0, 0));
		//controll_X = rotate(mat4(1.0), X_degree, vec3(cos(Y_degree), 0, sin(Y_degree)));
		if (clock_x == 6300) clock_x = 0;
	}
	if (look3) {
		Z_degree = clock_z / 1000.0;
		Y_degree = clock_y / 1000.0;
		clock_y += 1;
		if (clock_y == 6340) clock_y = 0;
		//torso_axis = vec3(cos(Z_degree), 0, -sin(Z_degree));
		clock_z += 1;
		//controll_Z = rotate(mat4(1.0), Z_degree, vec3(0, 1, 1));
		controll_Y = rotate(mat4(1.0), Y_degree, vec3(1, cos(X_degree), 1-sin(X_degree)));
		if (clock_z == 6340) clock_z = 0;
	}
	if (Left) {
		torso.x -= 0.005;
	}
	if (Right) {
		torso.x += 0.005;
	}
	if (Backward) {
		main_camera.position.z -= 0.005;
	}
	if (Forward) {
		main_camera.position.z += 0.005;
	}
	if (M_down) {
		double xx, yy;
		xx = -10 + curx / 40;
		yy = 15 - cury * 27 / 1000;
		torso = vec3(xx, yy + delta_y, torso.z);
		//torso = vec3(-8, 10, torso.z);
		//cout << curx << " , "<< cury <<"\n";
	}
	if (drag_down) {
		GLfloat dis = drag_x - curx;
		//OLD = Y_degree;
		//Y_degree += - dis / 100;
		OLD = Y_degree - dis / 100;
		controll_Y = rotate(mat4(1.0), OLD,vec3(0,1,0));
		torso_axis = vec3(cos(OLD), 0, -sin(OLD));
	}
	if (Roll) {
		head_axis = vec3(0, 1, 0);
		head_de -= 0.001;
	}
	if (Rollback) {
		head_axis = vec3(0, 1, 0);
		head_de += 0.001;
	}
}
void scroll_callback(GLFWwindow* window, double xoffset, double yoffset)
{
	// scroll up positive, otherwise it would be negtive
	printf("Scroll Event: (%f, %f)\n", xoffset, yoffset);
}

void mouse_button_callback(GLFWwindow* window, int button, int action, int mods)
{
	
	if (button == GLFW_MOUSE_BUTTON_LEFT && action == GLFW_PRESS) {
		printf("Click Mouse Left button!\n");
		if (!drag_mode) M_down = true;
		else {
			//Y_degree = OLD;
			drag_x = curx;
			drag_y = cury;
			drag_down = true;
		}
	}
	else if (button == GLFW_MOUSE_BUTTON_LEFT && action == GLFW_RELEASE) {
		printf("Release Mouse Left button!\n");
		if (!drag_mode) M_down = false;
		else {
			Y_degree = OLD;
			clock_y = 1000 * Y_degree;
			drag_down = false;
		}
	}
}

static void cursor_pos_callback(GLFWwindow* window, double xpos, double ypos)
{
	curx = xpos;
	cury = ypos;
	// callback rigistrate on mouse position
}

void setShaders()
{
	GLuint v, f, p;
	char *vs = NULL;
	char *fs = NULL;

	v = glCreateShader(GL_VERTEX_SHADER);
	f = glCreateShader(GL_FRAGMENT_SHADER);

	vs = textFileRead("shader.vs.glsl");
	fs = textFileRead("shader.fs.glsl");

	glShaderSource(v, 1, (const GLchar**)&vs, NULL);
	glShaderSource(f, 1, (const GLchar**)&fs, NULL);

	free(vs);
	free(fs);

	GLint success;
	char infoLog[1000];
	// compile vertex shader
	glCompileShader(v);
	// check for shader compile errors
	glGetShaderiv(v, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(v, 1000, NULL, infoLog);
		std::cout << "ERROR: VERTEX SHADER COMPILATION FAILED\n" << infoLog << std::endl;
	}

	// compile fragment shader
	glCompileShader(f);
	// check for shader compile errors
	glGetShaderiv(f, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(f, 1000, NULL, infoLog);
		std::cout << "ERROR: FRAGMENT SHADER COMPILATION FAILED\n" << infoLog << std::endl;
	}

	// create program object
	p = glCreateProgram();

	// attach shaders to program object
	glAttachShader(p,f);
	glAttachShader(p,v);

	// link program
	glLinkProgram(p);
	// check for linking errors
	glGetProgramiv(p, GL_LINK_STATUS, &success);
	if (!success) {
		glGetProgramInfoLog(p, 1000, NULL, infoLog);
		std::cout << "ERROR: SHADER PROGRAM LINKING FAILED\n" << infoLog << std::endl;
	}

	glDeleteShader(v);
	glDeleteShader(f);

	if (success)
		glUseProgram(p);
    else
    {
        system("pause");
        exit(123);
    }

	program = p;
}

void normalization(tinyobj::attrib_t* attrib, vector<GLfloat>& vertices, vector<GLfloat>& colors, vector<GLfloat>& normals, vector<GLfloat>& textureCoords, vector<int>& material_id, tinyobj::shape_t* shape)
{
	vector<float> xVector, yVector, zVector;
	float minX = 10000, maxX = -10000, minY = 10000, maxY = -10000, minZ = 10000, maxZ = -10000;

	// find out min and max value of X, Y and Z axis
	for (int i = 0; i < attrib->vertices.size(); i++)
	{
		//maxs = max(maxs, attrib->vertices.at(i));
		if (i % 3 == 0)
		{

			xVector.push_back(attrib->vertices.at(i));

			if (attrib->vertices.at(i) < minX)
			{
				minX = attrib->vertices.at(i);
			}

			if (attrib->vertices.at(i) > maxX)
			{
				maxX = attrib->vertices.at(i);
			}
		}
		else if (i % 3 == 1)
		{
			yVector.push_back(attrib->vertices.at(i));

			if (attrib->vertices.at(i) < minY)
			{
				minY = attrib->vertices.at(i);
			}

			if (attrib->vertices.at(i) > maxY)
			{
				maxY = attrib->vertices.at(i);
			}
		}
		else if (i % 3 == 2)
		{
			zVector.push_back(attrib->vertices.at(i));

			if (attrib->vertices.at(i) < minZ)
			{
				minZ = attrib->vertices.at(i);
			}

			if (attrib->vertices.at(i) > maxZ)
			{
				maxZ = attrib->vertices.at(i);
			}
		}
	}
	
	float offsetX = (maxX + minX) / 2;
	float offsetY = (maxY + minY) / 2;
	float offsetZ = (maxZ + minZ) / 2;

	for (int i = 0; i < attrib->vertices.size(); i++)
	{
		if (offsetX != 0 && i % 3 == 0)
		{
			attrib->vertices.at(i) = attrib->vertices.at(i) - offsetX;
		}
		else if (offsetY != 0 && i % 3 == 1)
		{
			attrib->vertices.at(i) = attrib->vertices.at(i) - offsetY;
		}
		else if (offsetZ != 0 && i % 3 == 2)
		{
			attrib->vertices.at(i) = attrib->vertices.at(i) - offsetZ;
		}
	}

	float greatestAxis = maxX - minX;
	float distanceOfYAxis = maxY - minY;
	float distanceOfZAxis = maxZ - minZ;

	if (distanceOfYAxis > greatestAxis)
	{
		greatestAxis = distanceOfYAxis;
	}

	if (distanceOfZAxis > greatestAxis)
	{
		greatestAxis = distanceOfZAxis;
	}

	float scale = greatestAxis / 2;

	for (int i = 0; i < attrib->vertices.size(); i++)
	{
		//std::cout << i << " = " << (double)(attrib.vertices.at(i) / greatestAxis) << std::endl;
		attrib->vertices.at(i) = attrib->vertices.at(i)/ scale;
	}
	size_t index_offset = 0;
	for (size_t f = 0; f < shape->mesh.num_face_vertices.size(); f++) {
		int fv = shape->mesh.num_face_vertices[f];

		// Loop over vertices in the face.
		for (size_t v = 0; v < fv; v++) {
			// access to vertex
			tinyobj::index_t idx = shape->mesh.indices[index_offset + v];
			vertices.push_back(attrib->vertices[3 * idx.vertex_index + 0]);
			vertices.push_back(attrib->vertices[3 * idx.vertex_index + 1]);
			vertices.push_back(attrib->vertices[3 * idx.vertex_index + 2]);
			// Optional: vertex colors
			colors.push_back(attrib->colors[3 * idx.vertex_index + 0]);
			colors.push_back(attrib->colors[3 * idx.vertex_index + 1]);
			colors.push_back(attrib->colors[3 * idx.vertex_index + 2]);
			// Optional: vertex normals
			normals.push_back(attrib->normals[3 * idx.normal_index + 0]);
			normals.push_back(attrib->normals[3 * idx.normal_index + 1]);
			normals.push_back(attrib->normals[3 * idx.normal_index + 2]);
			// Optional: texture coordinate
			textureCoords.push_back(attrib->texcoords[2 * idx.texcoord_index + 0]);
			textureCoords.push_back(attrib->texcoords[2 * idx.texcoord_index + 1]);
			// The material of this vertex
			material_id.push_back(shape->mesh.material_ids[f]);
		}
		index_offset += fv;
	}
}

static string GetBaseDir(const string& filepath) {
	if (filepath.find_last_of("/\\") != std::string::npos)
		return filepath.substr(0, filepath.find_last_of("/\\"));
	return "";
}


GLuint LoadTextureImage(string image_path)
{
	int channel, width, height;
	int require_channel = 4;
	stbi_set_flip_vertically_on_load(true);
	stbi_uc *data = stbi_load(image_path.c_str(), &width, &height, &channel, require_channel);
	cout << image_path.c_str()<<"\n";
	if (data != NULL)
	{
		GLuint tex;

		glGenTextures(1, &tex);
		glBindTexture(GL_TEXTURE_2D, tex);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
		glGenerateMipmap(GL_TEXTURE_2D);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

		stbi_image_free(data);
		return tex;
	}
	else
	{
		cout << "LoadTextureImage: Cannot load image from " << image_path << endl;
		return -1;
	}
}

vector<Shape> SplitShapeByMaterial(vector<GLfloat>& vertices, vector<GLfloat>& colors, vector<GLfloat>& normals, vector<GLfloat>& textureCoords, vector<int>& material_id, vector<PhongMaterial>& materials)
{
	vector<Shape> res;
	for (int m = 0; m < materials.size(); m++)
	{
		vector<GLfloat> m_vertices, m_colors, m_normals, m_textureCoords;
		
		for (int v = 0; v < material_id.size(); v++) 
		{
			// extract all vertices with same material id and create a new shape for it.
			if (material_id[v] == m)
			{
				m_vertices.push_back(vertices[v * 3 + 0]);
				m_vertices.push_back(vertices[v * 3 + 1]);
				m_vertices.push_back(vertices[v * 3 + 2]);

				m_colors.push_back(colors[v * 3 + 0]);
				m_colors.push_back(colors[v * 3 + 1]);
				m_colors.push_back(colors[v * 3 + 2]);

				m_normals.push_back(normals[v * 3 + 0]);
				m_normals.push_back(normals[v * 3 + 1]);
				m_normals.push_back(normals[v * 3 + 2]);

				m_textureCoords.push_back(textureCoords[v * 2 + 0]);
				m_textureCoords.push_back(textureCoords[v * 2 + 1]);
			}
		}

		if (!m_vertices.empty())
		{
			Shape tmp_shape;
			glGenVertexArrays(1, &tmp_shape.vao);
			glBindVertexArray(tmp_shape.vao);

			glGenBuffers(1, &tmp_shape.vbo);
			glBindBuffer(GL_ARRAY_BUFFER, tmp_shape.vbo);
			glBufferData(GL_ARRAY_BUFFER, m_vertices.size() * sizeof(GL_FLOAT), &m_vertices.at(0), GL_STATIC_DRAW);
			glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
			tmp_shape.vertex_count = m_vertices.size() / 3;

			glGenBuffers(1, &tmp_shape.p_color);
			glBindBuffer(GL_ARRAY_BUFFER, tmp_shape.p_color);
			glBufferData(GL_ARRAY_BUFFER, m_colors.size() * sizeof(GL_FLOAT), &m_colors.at(0), GL_STATIC_DRAW);
			glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, 0);

			glGenBuffers(1, &tmp_shape.p_normal);
			glBindBuffer(GL_ARRAY_BUFFER, tmp_shape.p_normal);
			glBufferData(GL_ARRAY_BUFFER, m_normals.size() * sizeof(GL_FLOAT), &m_normals.at(0), GL_STATIC_DRAW);
			glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 0, 0);

			glGenBuffers(1, &tmp_shape.p_texCoord);
			glBindBuffer(GL_ARRAY_BUFFER, tmp_shape.p_texCoord);
			glBufferData(GL_ARRAY_BUFFER, m_textureCoords.size() * sizeof(GL_FLOAT), &m_textureCoords.at(0), GL_STATIC_DRAW);
			glVertexAttribPointer(3, 2, GL_FLOAT, GL_FALSE, 0, 0);

			glEnableVertexAttribArray(0);
			glEnableVertexAttribArray(1);
			glEnableVertexAttribArray(2);
			glEnableVertexAttribArray(3);

			tmp_shape.material = materials[m];
			res.push_back(tmp_shape);
		}
	}

	return res;
}

void LoadTexturedModels(string model_path)
{
	vector<tinyobj::shape_t> shapes;
	vector<tinyobj::material_t> materials;
	tinyobj::attrib_t attrib;
	vector<GLfloat> vertices;
	vector<GLfloat> colors;
	vector<GLfloat> normals;
	vector<GLfloat> textureCoords;
	vector<int> material_id;

	string err;
	string warn;

	string base_dir = GetBaseDir(model_path); // handle .mtl with relative path
	

#ifdef _WIN32
	base_dir += "\\";
#else
	base_dir += "/";
#endif

	bool ret = tinyobj::LoadObj(&attrib, &shapes, &materials, &warn, &err, model_path.c_str(), base_dir.c_str());
	cout << "---" << model_path.c_str() << "\n";
	if (!warn.empty()) {
		cout << warn << std::endl;
		cout << "1";
	}

	if (!err.empty()) {
		cerr << err << std::endl;
		cout << "2";
	}

	if (!ret) {
		exit(1);
	}

	printf("Load Models Success ! Shapes size %d Material size %d\n", shapes.size(), materials.size());
	model tmp_model;

	vector<PhongMaterial> allMaterial;
	for (int i = 0; i < materials.size(); i++)
	{
		PhongMaterial material;
		material.diffuseTexture = LoadTextureImage(base_dir + string(materials[i].diffuse_texname));//控制外觀texture
		//string("test.bmp")string(materials[i].diffuse_texname)
		//cout << string(materials[i].diffuse_texname) << "\n";
		if (material.diffuseTexture == -1)
		{
			cout << "LoadTexturedModels: Fail to load model's material " << i << endl;
			system("pause");

			
		}
		
		allMaterial.push_back(material);
	}
	
	for (int i = 0; i < shapes.size(); i++)
	{

		vertices.clear();
		colors.clear();
		normals.clear();
		textureCoords.clear();
		material_id.clear();
		normalization(&attrib, vertices, colors, normals, textureCoords, material_id, &shapes[i]);
		// printf("Vertices size: %d", vertices.size() / 3);

		// split current shape into multiple shapes base on material_id.
		vector<Shape> splitedShapeByMaterial = SplitShapeByMaterial(vertices, colors, normals, textureCoords, material_id, allMaterial);

		// concatenate splited shape to model's shape list
		tmp_model.shapes.insert(tmp_model.shapes.end(), splitedShapeByMaterial.begin(), splitedShapeByMaterial.end());
	}
	shapes.clear();
	materials.clear();
	models.push_back(tmp_model);
}



void initParameter()
{
	proj.nearClip = 0.001;
	proj.farClip = 1000.0;
	proj.fovy = 80;
	proj.aspect = (float)(WINDOW_WIDTH) / (float)WINDOW_HEIGHT; // adjust width for side by side view

	main_camera.position = vec3(0.0f, 2.0f, 16.0f);
	main_camera.center = vec3(0.0f, 2.0f, 0.0f);
	main_camera.up_vector = vec3(0.0f, 1.0f, 0.0f);
}

void setUniformVariables()
{
	iLocP = glGetUniformLocation(program, "um4p");
	iLocV = glGetUniformLocation(program, "um4v");
	iLocM = glGetUniformLocation(program, "um4m");
}


void setupRC()
{
	// setup shaders
	setShaders();
	initParameter();
	setUniformVariables();

	// OpenGL States and Values
	glClearColor(0.2, 0.2, 0.2, 1.0);
	
	for (string model_path : model_list){
		LoadTexturedModels(model_path);
	}
}

void glPrintContextInfo(bool printExtension)
{
	cout << "GL_VENDOR = " << (const char*)glGetString(GL_VENDOR) << endl;
	cout << "GL_RENDERER = " << (const char*)glGetString(GL_RENDERER) << endl;
	cout << "GL_VERSION = " << (const char*)glGetString(GL_VERSION) << endl;
	cout << "GL_SHADING_LANGUAGE_VERSION = " << (const char*)glGetString(GL_SHADING_LANGUAGE_VERSION) << endl;
	if (printExtension)
	{
		GLint numExt;
		glGetIntegerv(GL_NUM_EXTENSIONS, &numExt);
		cout << "GL_EXTENSIONS =" << endl;
		for (GLint i = 0; i < numExt; i++)
		{
			cout << "\t" << (const char*)glGetStringi(GL_EXTENSIONS, i) << endl;
		}
	}
}

void do_action() {
	wave_hand();
	jump();
	_Rotate();
}
int main(int argc, char **argv)
{

    // initial glfw
	init();
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); // fix compilation on OS X
#endif

    
    // create window
	GLFWwindow* window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Student_ID CG Training Coarse", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    
    
    // load OpenGL function pointer
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }

	glPrintContextInfo(false);
    
	// register glfw callback functions
    glfwSetKeyCallback(window, KeyCallback);
	glfwSetScrollCallback(window, scroll_callback);
	glfwSetMouseButtonCallback(window, mouse_button_callback);
	glfwSetCursorPosCallback(window, cursor_pos_callback);
    glfwSetFramebufferSizeCallback(window, ChangeSize);

	glEnable(GL_DEPTH_TEST);
	// Setup render context
	setupRC();

	// main loop
    while (!glfwWindowShouldClose(window))
    {
		/*GLfloat light_position[] = { 0.0, 0.0, 0.0, 0.0 };
		GLfloat light_ambient[] = { 0.0, 0.0, 0.0, 1.0 };
		GLfloat light_diffuse[] = { 1.0, 1.0, 1.0, 1.0 };
		GLfloat light_specular[] = { 1.0, 1.0, 1.0, 1.0 };
		glLightfv(GL_LIGHT0, GL_POSITION, light_position);
		glLightfv(GL_LIGHT0, GL_AMBIENT, light_ambient);
		glLightfv(GL_LIGHT0, GL_DIFFUSE, light_diffuse);
		glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular);

		glEnable(GL_LIGHTING);
		glEnable(GL_LIGHT0);
		glEnable(GL_DEPTH_TEST);*/
        // Render
		RenderScene(cur_idx);
		//controll_Y = rotate(mat4(1.0), Y_degree, vec3(0+v, cos(X_degree)+b, -sin(X_degree)+n));
		/*Y_degree = glfwGetTime() / 2.0;
		ray = vec3(0.0, 1.0, 0.0);
		controll_Y = rotate(mat4(1.0), Y_degree, ray);*/
		do_action();
		//RenderScene(cur_idx2);
		
        
        // swap buffer from back to front
        glfwSwapBuffers(window);
        
        // Poll input event
        glfwPollEvents();
    }
	
	// just for compatibiliy purposes
	return 0;
}
