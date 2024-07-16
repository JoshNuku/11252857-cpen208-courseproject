/* eslint-disable @next/next/no-async-client-component */
"use client";
import Card from "../components/card";
import Footer from "../components/footer";
import Navbar from "../components/navbar";
import { notFound, useRouter } from "next/navigation";
import { useSession } from "next-auth/react";
import { authOptions } from "../api/auth/[...nextauth]/route";
import { getRegisteredCourses } from "@/actions";
import { displayCourses } from "./[courseCode]/page";

/* export async function checkSession() {
  const session = await getServerSession(authOptions);
  return session?.user;
} */
export default async function Dashboard(props: { params: { id: string } }) {
  const user = useSession();
  const router = useRouter();
  const { data: session, status } = user;
  if (!(status === "authenticated") || session.user.id !== props.params.id)
    return router.push("/login/404");
  const regCourses = await displayCourses(Card, props.params.id, null);
  console.log(regCourses);
  return (
    <>
      <Navbar id={props.params.id} />
      <h1 className="text-center mt-8 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
        Welcome {session?.user.name}!
      </h1>
      <h2 className="text-start ms-5 mt-8 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
        {regCourses.length ? "Registered Courses" : "No courses registered"}
      </h2>
      <div className="grid grid-cols-1 gap-4 md:grid-cols-3 flex-grow">
        {regCourses}
      </div>

      <Footer />
    </>
  );
}
