import Card2 from "../../components/card2";
import Footer from "../../components/footer";
import Navbar from "../../components/navbar";

export default function course_info() {
  return (
    <>
      <Navbar />
      <div className="flex justify-center flex-grow">
        <Card2 />
      </div>
      <Footer />
    </>
  );
}
