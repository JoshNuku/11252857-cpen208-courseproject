/* eslint-disable @next/next/no-async-client-component */
"use client";
import Card from "../components/card";
import Footer from "../components/footer";
import Navbar from "../components/navbar";
import { useRouter } from "next/navigation";
import { useSession } from "next-auth/react";
import { authOptions } from "../api/auth/[...nextauth]/route";

// Add other NextAuth utility functions as needed
/* export async function checkSession() {
  const session = await getServerSession(authOptions);
  return session?.user;
} */
export default function Dashboard(props: { params: { id: string } }) {
  // const user = await checkSession();
  // if (!(user?.id == props.params.id)) return redirect("/login");
  const user = useSession();
  const router = useRouter();
  // console.log(user);
  const { data: session, status } = user;
  if (!(status === "authenticated") || session.user.id !== props.params.id)
    return router.push("/login");

  return (
    <>
      <Navbar />
      <h1 className="text-center mt-8 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
        Welcome {session.user.name}!
      </h1>
      <h2 className="text-start ms-5 mt-8 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
        Registered Courses
      </h2>
      <div className="grid grid-cols-1 gap-4 md:grid-cols-3 flex-grow">
        <Card />
      </div>

      <Footer />
    </>
  );
}
