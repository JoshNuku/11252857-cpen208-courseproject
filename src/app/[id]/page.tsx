import Card from "../components/card";
import Footer from "../components/footer";
import Navbar from "../components/navbar";

export default async function Dashboard(props: { params: { id: string } }) {
  await new Promise((r) => setTimeout(r, 3000));
  console.log(props);
  return (
    <>
      <Navbar />
      <h1 className="text-center mt-8 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
        Registered Courses
      </h1>
      <div className="grid grid-cols-1 gap-4 md:grid-cols-3 flex-grow">
        <Card />
      </div>

      <Footer />
    </>
  );
}
