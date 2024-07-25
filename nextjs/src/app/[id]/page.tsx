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
import { Alert } from "flowbite-react";
import { useState } from "react";
import axios from "axios";
import { TfiAnnouncement } from "react-icons/tfi";

/* export async function checkSession() {
  const session = await getServerSession(authOptions);
  return session?.user;
} */
export default async function Dashboard(props: { params: { id: string } }) {
  const user = useSession();
  const router = useRouter();
  const [show, setShow] = useState(true);
  function handleDismiss() {
    const res = !show;
    setShow(res);
  }
  const { data: session, status } = user;
  const finances = await (
    await axios.get("http://localhost:5051/finances/outstanding_fees")
  ).data.find((stu: any) => stu.student_id == session?.user.id);
  if (!(status === "authenticated") || session.user.id !== props.params.id)
    return router.push("/login");
  const regCourses = await displayCourses(Card, props.params.id, null);
  console.log(regCourses);
  return (
    <>
      <Navbar id={props.params.id} />
      <h1 className="bg-white dark:bg-gray-800 p-10 mt-8 text-2xl font-bold tracking-tight text-gray-900 dark:text-white m-5 rounded-lg">
        Welcome {session?.user.name}!
      </h1>

      <div className="grid grid-cols-1 gap-4">
        <div className="grid grid-cols-1 md:grid-cols-3 text-black">
          <div className="">
            <Calender />
          </div>
          <div className="rounded-lg shadow-lg col-span-2 p-5 bg-white dark:bg-gray-800 me-3 dark:text-white">
            <h1 className="mx-3 dark:text-white text-5xl">
              <TfiAnnouncement />
            </h1>
            {show ? (
              <p>
                <Alert color="success" className="m-5 text-dark">
                  <span className="text-dark font-bold m-5">
                    {" "}
                    You have registered {regCourses.length} courses
                  </span>
                </Alert>
              </p>
            ) : (
              <p>
                <Alert color="success" className="m-5 text-dark">
                  <span className="text-dark font-bold m-5">
                    {" "}
                    Nothing here yet
                  </span>
                </Alert>
              </p>
            )}
            {show ? (
              <p>
                <Alert color="success" className="m-5 text-dark">
                  <span className="text-dark font-bold m-5">
                    You have {6 - regCourses.length} courses left to register
                  </span>
                </Alert>
              </p>
            ) : null}
            {show ? (
              <p>
                <Alert color="warning" className=" m-5 text-dark">
                  <span className="text-dark font-bold m-5">
                    You owe the institution GHS{finances.outstanding_fees}
                  </span>{" "}
                </Alert>
              </p>
            ) : null}
            {show ? (
              <>
                <button
                  onClick={handleDismiss}
                  className=" ms-5 text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                >
                  Dismiss
                </button>{" "}
                <Link
                  className="ms-5 text-white bg-gray-700 hover:bg-gray-800 focus:ring-4 focus:outline-none focus:ring-gray-300 font-medium rounded-lg text-sm px-4 py-2 text-center dark:bg-gray-600 dark:hover:bg-gray-700 dark:focus:ring-gray-800"
                  href={`${props.params.id}/register_course`}
                >
                  Register more courses
                </Link>
              </>
            ) : null}
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
