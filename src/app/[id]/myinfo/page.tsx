import Footer from "@/app/components/footer";
import Navbar from "@/app/components/navbar";

export default function AboutMePage() {
  return (
    <div className="">
      <Navbar />
      <h1 className="text-center dark:text-white mt-9 text-4xl font-medium">
        {" "}
        My Info
      </h1>
      <div className="grid grid-cols-1 md:grid-cols-2 my-7 mx-5 flex-grow mb-60">
        <div className="grid my-9 justify-items-center">
          <img
            className="w-6/12 rounded-full"
            src="https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?q=80&w=1434&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
            alt=""
          />
        </div>
        <ul className="max-w-md divide-y divide-gray-200 dark:divide-gray-700 self-center">
          <li className="pb-3 sm:pb-4">
            <div className="flex items-center space-x-4 rtl:space-x-reverse">
              <div className="flex-shrink-0"></div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-gray-900 truncate dark:text-white">
                  Joshua Nuku
                </p>
              </div>
            </div>
          </li>
          <li className="py-3 sm:py-4">
            <div className="flex items-center space-x-4 rtl:space-x-reverse">
              <div className="flex-shrink-0"></div>
              <div className="flex-1 min-w-0">
                <p className="text-sm text-gray-500 truncate dark:text-gray-400">
                  11252857
                </p>
              </div>
            </div>
          </li>
          <li className="py-3 sm:py-4">
            <div className="flex items-center space-x-4 rtl:space-x-reverse">
              <div className="flex-shrink-0"></div>
              <div className="flex-1 min-w-0">
                <p className="text-sm text-gray-500 truncate dark:text-gray-400">
                  nukujosh119@gmail.com
                </p>
              </div>
            </div>
          </li>
          <li className="py-3 sm:py-4">
            <div className="flex items-center space-x-4 rtl:space-x-reverse">
              <div className="flex-shrink-0"></div>
              <div className="flex-1 min-w-0">
                <p className="text-sm text-gray-500 truncate dark:text-gray-400">
                  CPEN 200
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
                $367
              </div>
            </div>
          </li>
        </ul>
      </div>
      <Footer />
    </div>
  );
}
