<script>
  import { UploadIcon, DownloadIcon } from 'svelte-feather-icons';

  let uploaded_image, fileinput;

  async function onFileSelected(e) {
    let image = e.target.files[0];
    let reader = new FileReader();
    reader.readAsDataURL(image);
    reader.onload = (e) => {
      uploaded_image = e.target.result;
    };
  }

  let done = false;
  let ascii_image;

  async function getAscii() {
    let request = await fetch('./img', {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ image: uploaded_image }),
    });
    request = await request.json();
    done = true;
    ascii_image = request.image;
  }
</script>

<svelte:head>
  <title>ASCII ART Convertor</title>
</svelte:head>

<div id="app">
  <h1>ASCII ART Convertor by <span>drawbu</span></h1>

  {#if !done}
    <button
      on:click={() => {
        fileinput.click();
      }}
    >
      <UploadIcon />
      <span>Choose Image</span>
    </button>
  {:else}
    <a download="result.png" href={ascii_image}>
      <button>
        <DownloadIcon />
        Download!
      </button>
    </a>
  {/if}

  <input
    style="display:none"
    type="file"
    accept=".jpg, .jpeg, .png"
    on:change={(e) => onFileSelected(e)}
    bind:this={fileinput}
  />

  {#if uploaded_image}
    <div class="images">
      <div class="img">
        <img src={uploaded_image} alt="" />
        <p>Original</p>
      </div>
      <div class="img">
        {#await getAscii()}
          Waiting for the server to send the result...
        {:then}
          <img src={ascii_image} alt="" />
          <p>Result</p>
        {/await}
      </div>
    </div>
  {/if}
</div>

<style lang="scss">
  #app {
    display: flex;
    flex-direction: column;
    width: 800px;
    margin: auto;

    @media (max-width: 840px) {
      width: auto;

      h1 {
        text-align: center;
      }

      .images {
        flex-direction: column;
      }
    }

    h1 {
      margin: auto;
      margin-bottom: 30px;

      span {
        color: #4ea5d9;
      }
    }

    button {
      margin: auto;
      margin-top: 10px;
      margin-bottom: 10px;
      cursor: pointer;
      border-radius: 5px;
      border: 2px solid lightgray;
      display: flex;
      align-items: center;
      transition-duration: 150ms;
      gap: 5px;

      &:hover {
        border-color: #4ea5d9;
        color: #4ea5d9;
      }
    }

    .images {
      margin: auto;
      display: flex;
      gap: 20px;

      .img {
        width: 390px;

        img {
          margin: 0 auto;
          width: 390px;
        }

        p {
          text-align: center;
        }
      }
    }

    a {
      margin: auto;

      &:hover {
        text-decoration: none;
      }
    }
  }
</style>
