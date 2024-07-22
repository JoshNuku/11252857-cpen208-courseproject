/* eslint-disable @next/next/no-async-client-component */
"use client";
import Card from "../components/card";
import Footer from "../components/footer";
import Navbar from "../components/navbar";
import { useRouter } from "next/navigation";
import { useSession } from "next-auth/react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faSquarePlus } from "@fortawesome/free-solid-svg-icons";
import { displayCourses } from "./[courseCode]/page";
import Link from "next/link";
import Calender from "../components/calender";

/* export async function checkSession() {
  const session = await getServerSession(authOptions);
  return session?.user;
} */
export default async function Dashboard(props: { params: { id: string } }) {
  const user = useSession();
  const router = useRouter();
  const { data: session, status } = user;
  if (!(status === "authenticated") || session.user.id !== props.params.id)
    return router.push("/login");
  const regCourses = await displayCourses(Card, props.params.id, null);
  console.log(regCourses);
  return (
    <>
      <Navbar id={props.params.id} />
      <h1 className="text-center mt-8 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
        Welcome {session?.user.name}!
      </h1>

      <div className="grid grid-cols-1 gap-4">
        <div className="grid grid-cols-1 md:grid-cols-3 text-black">
          <div className="cols-span-2">
            <Calender />
          </div>
        </div>
        <h2 className="text-start ms-5 mt-8 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
          {regCourses.length ? (
            "Registered Courses"
          ) : (
            <Link
              href={`${props.params.id}/register_course`}
              className="flex justify-center items-center h-screen"
            >
              <FontAwesomeIcon icon={faSquarePlus} className="text-4xl" />
            </Link>
          )}
        </h2>
        <div className="grid grid-cols-1 gap-4 md:grid-cols-4">
          {regCourses}
        </div>
      </div>

      <Footer />
    </>
  );
}
