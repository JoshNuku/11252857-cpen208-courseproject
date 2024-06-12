import Footer from "@/app/components/footer";
import Navbar from "@/app/components/navbar";
import Select_course from "@/app/components/select_course";

export default function RegisterCourse() {
  const courses = [
    {
      courseName: "Data Structures And Algorithm",
      courseCode: "CPEN 202",
      credit: "2",
      lecturer: "Dr. Mageret",
      ta: "Foster",
    },
    {
      courseName: "Linear Circuit",
      courseCode: "CPEN 206",
      credit: "3",
      lecturer: "Dr. Mills",
      ta: "Hakeem",
    },
    {
      courseName: "Data Communication",
      courseCode: "CPEN 212",
      credit: "2",
      lecturer: "Dr. Isaac",
      ta: "Abdul Samed",
    },
    {
      courseName: "Differential Equations",
      courseCode: "SENG 202",
      credit: "4",
      lecturer: "Dr. Kutor",
      ta: "Thaddeus",
    },
  ];
  function displayCourses() {
    const arr = [];
    for (let course of courses) {
      arr.push(<Select_course props={course} />);
    }
    return arr;
  }
  return (
    <div>
      <Navbar />
      <div className="mt-5 pb-40">
        <section className="bg-gray-50 dark:bg-gray-900 p-3 sm:p-5 antialiased ">
          <div className="mx-auto max-w-screen-2xl px-4 lg:px-12 flex-grow">
            <div className="bg-white dark:bg-gray-800 relative shadow-md sm:rounded-lg overflow-hidden rounded-lg">
              <div className="flex flex-col md:flex-row md:items-center md:justify-between space-y-3 md:space-y-0 md:space-x-4 p-4">
                <div className="flex-1 flex items-center space-x-2">
                  <h5>
                    <span className="text-gray-500">All Courses</span>
                  </h5>
                </div>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                  <thead className="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                    <tr>
                      <th scope="col" className="p-4">
                        <div className="flex items-center"></div>
                      </th>
                      <th scope="col" className="p-4">
                        Course
                      </th>
                      <th scope="col" className="p-4">
                        Course Code
                      </th>
                      <th scope="col" className="p-4">
                        Credit Hours
                      </th>
                      <th scope="col" className="p-4">
                        Lecturer
                      </th>
                      <th scope="col" className="p-4">
                        TA
                      </th>
                    </tr>
                  </thead>
                  {displayCourses()}
                </table>
              </div>
            </div>
            <button className="flex items-center justify-center text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-primary-600 dark:hover:bg-primary-700 focus:outline-none dark:focus:ring-primary-800 mt-5 ms-5">
              {" "}
              Register
            </button>
          </div>
        </section>
      </div>
      <Footer />
    </div>
  );
}
