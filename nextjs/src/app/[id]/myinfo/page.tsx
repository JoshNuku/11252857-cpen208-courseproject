/* eslint-disable @next/next/no-async-client-component */
"use client";
import Footer from "@/app/components/footer";
import Navbar from "@/app/components/navbar";
import axios from "axios";
import img from "../../../../public/profile-circle-svgrepo-com.svg";
import { useSession } from "next-auth/react";
import { useRouter } from "next/navigation";
import { Card } from "flowbite-react";
export async function getstudentData(id: string) {
  try {
    // const res =

    // const info = await res.data.data;
    const student = await (
      await axios.get("http://localhost:5051/api/all_students")
    ).data.data.find((stu: any) => stu.student_id == id);

    const finances = await (
      await axios.get("http://localhost:5051/finances/outstanding_fees")
    ).data.find((stu: any) => stu.student_id == id);

    const data = {
      student,
      finances,
    };
    console.log(data);
    return data;
  } catch (e: any) {
    console.log(e);
    return e.message;
  }
}

export default async function AboutMePage(props: { params: { id: string } }) {
  const user = useSession();
  const router = useRouter();
  const { data: session, status } = user;
  if (!(status === "authenticated") || session.user.id !== props.params.id)
    return router.push("/login");

  const { student, finances } = await getstudentData(props.params.id);

  return (
    <div className="">
      <Navbar id={props.params.id} />
      <div className="flex flex-grow justify-center my-20">
        <Card className="max-w-sm ">
          <div className="flex justify-end px-4 pt-4"></div>
          <div className="flex flex-col items-center pb-5">
            <svg
              className="w-6/12 rounded-3xl text-white"
              viewBox="0 0 24 24"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                opacity="0.4"
                d="M12.1207 12.78C12.0507 12.77 11.9607 12.77 11.8807 12.78C10.1207 12.72 8.7207 11.28 8.7207 9.50998C8.7207 7.69998 10.1807 6.22998 12.0007 6.22998C13.8107 6.22998 15.2807 7.69998 15.2807 9.50998C15.2707 11.28 13.8807 12.72 12.1207 12.78Z"
                stroke="#677f8b"
                stroke-width="1.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <path
                opacity="0.34"
                d="M18.7398 19.3801C16.9598 21.0101 14.5998 22.0001 11.9998 22.0001C9.39977 22.0001 7.03977 21.0101 5.25977 19.3801C5.35977 18.4401 5.95977 17.5201 7.02977 16.8001C9.76977 14.9801 14.2498 14.9801 16.9698 16.8001C18.0398 17.5201 18.6398 18.4401 18.7398 19.3801Z"
                stroke="#677f8b"
                stroke-width="1.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <path
                d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z"
                stroke="#677f8b"
                stroke-width="1.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
            </svg>
            <h5 className="mb-1 text-xl font-medium text-gray-900 dark:text-white">
              {" "}
              {student.first_name} {student.last_name}
            </h5>
            <span className="text-sm text-gray-500 dark:text-gray-400">
              {" "}
              {student.student_id} - CPEN {student.level}
            </span>
            <div className="mt-4 flex space-x-3 lg:mt-6">
              <div className="inline-flex items-center rounded-lg bg-cyan-700 px-4 py-2 text-center text-sm font-medium text-white hover:bg-cyan-800 focus:outline-none focus:ring-4 focus:ring-cyan-300 dark:bg-cyan-600 dark:hover:bg-cyan-700 dark:focus:ring-cyan-800">
                {student.email}
              </div>
              <div className="inline-flex items-center rounded-lg border border-gray-300 bg-white px-4 py-2 text-center text-sm font-medium text-gray-900 hover:bg-gray-100 focus:outline-none focus:ring-4 focus:ring-gray-200 dark:border-gray-600 dark:bg-gray-800 dark:text-white dark:hover:border-gray-700 dark:hover:bg-gray-700 dark:focus:ring-gray-700">
                You owe GHS {finances.outstanding_fees}
              </div>
            </div>
          </div>
        </Card>
      </div>

      {/*  <div className="grid grid-cols-1 md:grid-cols-2 my-7 mx-5 flex-grow mb-48">
       <div className="grid my-9 justify-items-center">
         {/*   <img className="w-6/12 rounded-3xl" src={img} alt="" /> */}
      {/*       <svg
        className="w-6/12 rounded-3xl text-white"
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          opacity="0.4"
          d="M12.1207 12.78C12.0507 12.77 11.9607 12.77 11.8807 12.78C10.1207 12.72 8.7207 11.28 8.7207 9.50998C8.7207 7.69998 10.1807 6.22998 12.0007 6.22998C13.8107 6.22998 15.2807 7.69998 15.2807 9.50998C15.2707 11.28 13.8807 12.72 12.1207 12.78Z"
          stroke="#677f8b"
          stroke-width="1.5"
          stroke-linecap="round"
          stroke-linejoin="round" />
        <path
          opacity="0.34"
          d="M18.7398 19.3801C16.9598 21.0101 14.5998 22.0001 11.9998 22.0001C9.39977 22.0001 7.03977 21.0101 5.25977 19.3801C5.35977 18.4401 5.95977 17.5201 7.02977 16.8001C9.76977 14.9801 14.2498 14.9801 16.9698 16.8001C18.0398 17.5201 18.6398 18.4401 18.7398 19.3801Z"
          stroke="#677f8b"
          stroke-width="1.5"
          stroke-linecap="round"
          stroke-linejoin="round" />
        <path
          d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z"
          stroke="#677f8b"
          stroke-width="1.5"
          stroke-linecap="round"
          stroke-linejoin="round" />
      </svg>
    </div><ul className="max-w-md divide-y divide-gray-200 dark:divide-gray-700 self-center justify-items-center sm:ms-20 border rounded-lg p-5">
        <li className="pb-3 sm:pb-4">
          <div className="flex items-center space-x-4 rtl:space-x-reverse">
            <div className="flex-shrink-0"></div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-gray-900 truncate dark:text-white">
                {student.first_name} {student.last_name}
              </p>
            </div>
          </div>
        </li>
        <li className="py-3 sm:py-4">
          <div className="flex items-center space-x-4 rtl:space-x-reverse">
            <div className="flex-shrink-0"></div>
            <div className="flex-1 min-w-0">
              <p className="text-sm text-gray-500 truncate dark:text-gray-400">
                {student.student_id}
              </p>
            </div>
          </div>
        </li>
        <li className="py-3 sm:py-4">
          <div className="flex items-center space-x-4 rtl:space-x-reverse">
            <div className="flex-shrink-0"></div>
            <div className="flex-1 min-w-0">
              <p className="text-sm text-gray-500 truncate dark:text-gray-400">
                {student.email}
              </p>
            </div>
          </div>
        </li>
        <li className="py-3 sm:py-4">
          <div className="flex items-center space-x-4 rtl:space-x-reverse">
            <div className="flex-shrink-0"></div>
            <div className="flex-1 min-w-0">
              <p className="text-sm text-gray-500 truncate dark:text-gray-400">
                CPEN {student.level}
              </p>
            </div>
          </div>
        </li>
        <li className="pt-3 pb-0 sm:pt-4">
          <div className="flex items-center space-x-4 rtl:space-x-reverse">
            <div className="flex-shrink-0"></div>
            <div className="flex-1 min-w-0">
              <p className="text-sm text-gray-500 truncate dark:text-gray-400">
                Outstanding fees
              </p>
            </div>
            <div className="inline-flex items-center text-base  text-gray-900 dark:text-white">
              GHS {finances.outstanding_fees}
            </div>
          </div>
        </li>
      </ul></>
      </div> */}
      <Footer />
    </div>
  );
}
