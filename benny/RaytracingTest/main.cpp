#include "ppmImage.h"
#include "math3d.h"
#include "profileTimer.h"
#include "display.h"
#include "globalData.h"
#include "mesh.h"
#include <iostream>

#define WIDTH 320
#define HEIGHT 240

static Mesh g_mesh("res/capsule.obj");
static Vector3f g_cameraPos(0,0,-3);

bool RayIntersectSphere(const Vector3f& spherePosition, float sphereRadius, const Ray& ray, RayIntersectData* intersectData)
{
	Vector3f rorig = *ray.GetOrigin() - spherePosition;
	Vector3f rdir = *ray.GetDirection();
	
	float radius2 = sphereRadius * sphereRadius;
	float a = rdir.LengthSq();
	float b = 2 * rdir.Dot(rorig);
	float c = rorig.LengthSq() - radius2;
	float t0, t1;
	if (!solveQuadratic(a, b, c, t0, t1) || t1 < 0) return false;
	if (t1 < t0) std::swap(t0, t1);
	intersectData->t = (t0 < 0) ? t1 : t0; 
	return true;
}

void Render(Display* output)
{
	RayIntersectData rayData;
	float fovTan = 2;
	
	GlobalData::g_numTriangles += g_mesh.GetNumTriangles();
	
	//Vector3f lightDirection = Vector3f(9,9,16).Normalized();
	
	for(int j = 0; j < HEIGHT; j++)
	{
		for(int i = 0; i < WIDTH; i++)
		{
			float x = ((2.0f * (float)i)/(float)WIDTH - 1.0f);
			float y = -((2.0f * (float)j)/(float)HEIGHT - 1.0f);
			
			Vector3f currentPixel;
			Vector3f rayPos(x,y,g_cameraPos.GetZ() + fovTan);
			Ray currentRay(rayPos,g_cameraPos - rayPos);
			
			//TODO: Move this to a more appropriate location;
			GlobalData::g_numRaysCast++;
			
			if(g_mesh.IntersectsRay(currentRay, &rayData))
			{
				Vector3f intersectPos = currentRay(rayData.t);
				
				float colorValue = Clamp(((1.0f - intersectPos.GetZ()) - 1.0f), 0.0f, 1.0f) ;
				currentPixel = Vector3f(colorValue, colorValue, colorValue);
				//currentPixel = Vector3f(1 - rayData.u - rayData.v, rayData.u, rayData.v);
			}
			else
			{
				float planeDenom = currentRay.GetDirection()->GetY(); //currentRay.GetDirection().Dot(Vector3f(0,1,0));
				
				if(planeDenom >= 1e-6)
				{
					Vector3f planePos = Vector3f(0,-7,0);
					float t = -(planePos - *currentRay.GetDirection()).GetY()/planeDenom;
					Vector3f intersectPos = currentRay(t) * 0.2f;
					
					Vector3f color1(0.45f,0.225f,0.0f);
					Vector3f color2(1,1,1);
					
					currentPixel = ((int)(ceil(intersectPos.GetX())+ceil(intersectPos.GetZ()))&1?color1:color2);
				}
				else
				{
					//Vector3f(0.7f,0.6f,1.0f)
					currentPixel = Vector3f(0.7f,0.6f,0.5f)*pow(1+currentRay.GetDirection()->GetY(),2);
				}
			}
			
			output->DrawPixel(i, j, currentPixel);
		}
	}
}

int main(int argc, char **argv)
{
	Display display(WIDTH, HEIGHT, 2.0f, "Raytracing Test");
	ProfileTimer timer;
	
	double lastDisplayTime = timer.GetTime();
	float totalTimeInSeconds = 0.0;
	int numRendered = 0;
	while(!display.IsClosed())
	{
		timer.Start();
		Render(&display);
		
		float delta = timer.End();
		totalTimeInSeconds += delta;
		display.Update(&g_cameraPos, delta);
		numRendered++;
		if(timer.GetTime() - lastDisplayTime >= 1.0)
		{
			float avgTimeInSeconds = totalTimeInSeconds/numRendered;
			int avgNumRaysCast = (int)((float)GlobalData::g_numRaysCast/(float)numRendered);
			int avgNumTriangles = (int)((float)GlobalData::g_numTriangles/(float)numRendered);
			int avgNumTriangleIntersectionTest = (int)((float)GlobalData::g_numTriangleIntersectionTest/(float)numRendered);
			int avgNumTrianglesIntersected = (int)((float)GlobalData::g_numTrianglesIntersected/(float)numRendered);
			int avgNumAABBIntersectionTests = (int)((float)GlobalData::g_numAABBIntersectionTests/(float)numRendered);
			int avgNumAABBIntersected = (int)((float)GlobalData::g_numAABBIntersected/(float)numRendered);
			
			std::cout << "Render time: " << avgTimeInSeconds << " seconds (" << (1.0/avgTimeInSeconds) << " fps)" << std::endl;
			std::cout << "Rays Cast: " << avgNumRaysCast << std::endl;
			std::cout << "Num Triangles: " << avgNumTriangles << std::endl;
			std::cout << "Triangle Intersection Tests: " << avgNumTriangleIntersectionTest << std::endl;
			std::cout << "Triangle Intersections: " << avgNumTrianglesIntersected << std::endl;
			std::cout << "AABB Intersection Tests: " << avgNumAABBIntersectionTests << std::endl;
			std::cout << "AABB Intersections: " << avgNumAABBIntersected << std::endl;
			
			totalTimeInSeconds = 0.0f;
			numRendered = 0;
			lastDisplayTime = timer.GetTime();
			GlobalData::g_numRaysCast = 0;
			GlobalData::g_numTriangleIntersectionTest = 0;
			GlobalData::g_numTrianglesIntersected = 0;
			GlobalData::g_numTriangles = 0;
			GlobalData::g_numAABBIntersectionTests = 0;
			GlobalData::g_numAABBIntersected = 0;
		}
	}
	
	return 0;
}
