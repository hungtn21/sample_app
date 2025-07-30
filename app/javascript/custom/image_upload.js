document.addEventListener("turbo:load", function () {
  const image_upload = document.querySelector("#micropost_image");
  if (!image_upload) return;

  image_upload.addEventListener("change", function (event) {
    const size_in_megabytes = image_upload.files[0].size / 1024 / 1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t("errors.messages.file_too_large"));
      image_upload.value = "";
    }
  });
});
